const execSync = require('child_process').execSync;

// list of modules to test
const modules = [
  'modules/simple',
];

// run a command test with various printing options
function runCmdTest (header, command, timeout=0) {
  var success = true;
  console.log('-'.repeat(80));
  console.log(header);
  console.log(`> ${command}`)
  try {
    execSync(command, {
      timeout: timeout,
      stdio: 'inherit',
      shell: true
    });
  } catch (error) { success = false; }
  console.log(`success: ${success}`)
  return success;
}

// run tests against all modules
async function runTests () {
  // initial overall status is true
  var overallStatus = true;
  // loop over all modules
  for (const module of modules) {
    // clean module (timeout: default)
    if (!runCmdTest(`cleaning: ${module}`, 
      `rm -rf ${module}/.terraform ${module}/terraform.tfstate*`)) {
      overallStatus = false; continue; // fail and continue to next module
    }
    // init module (timeout: default)
    if (!runCmdTest(`testing - terraform init: ${module}`, 
      `terraform -chdir=${module} init -input=false -compact-warnings`)) {
      overallStatus = false; continue; // fail and continue to next module
    }
    // validate module (timeout: default)
    if (!runCmdTest(`testing - terraform validate: ${module}`, 
      `terraform -chdir=${module} validate -compact-warnings`)) {
      overallStatus = false; continue; // fail and continue to next module
    }
    // apply module (timeout: 120 seconds)
    if (!runCmdTest(`-- testing - terraform apply: ${module}`, 
      `terraform -chdir=${module} apply -auto-approve -input=false -compact-warnings`)) {
      overallStatus = false; // fail and continue within this module
    }
    // destroy module (timeout: default)
    if (!runCmdTest(`-- testing - terraform destroy: ${module}`, 
      `terraform -chdir=${module} destroy -auto-approve -input=false -compact-warnings`)) {
      overallStatus = false; // fail and continue within this module
    }
  }
  // return overall status
  return overallStatus;
}

// run tests and exit in error if needed
if (!runTests()) process.exit(1);