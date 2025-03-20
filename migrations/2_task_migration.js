const TaskRewards = artifacts.require("TaskRewards");

module.exports = function (deployer) {
  deployer.deploy(TaskRewards);
};