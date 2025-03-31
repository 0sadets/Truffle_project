// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract TaskRewards {
    struct Task {
        address payable employer;  
        address payable worker;    
        string description;       
        uint reward;            
        bool isCompleted;          
        bool isTaken;              
    }

    Task[] public tasks;

    function createTask(string memory _description) public payable {
        require(msg.value > 0, "You must specify a reward.");

        Task memory newTask = Task({
            employer: payable(msg.sender),
            worker: payable(address(0)),
            description: _description,
            reward: msg.value,
            isCompleted: false,
            isTaken: false
        });

        tasks.push(newTask);
    }

    function takeTask(uint _taskId) public {
        require(_taskId < tasks.length, "There is no such task.");
        require(tasks[_taskId].isTaken == false, "The task is already taken.");

        tasks[_taskId].worker = payable(msg.sender);
        tasks[_taskId].isTaken = true;
    }

    function confirmTask(uint _taskId) public {
        require(_taskId < tasks.length, "There is no such task.");
        require(tasks[_taskId].isTaken == true, "The task has not yet been taken.");
        require(tasks[_taskId].isCompleted == false, "Task already completed");
        require(msg.sender == tasks[_taskId].employer, "Only the customer can confirm");

        tasks[_taskId].isCompleted = true;
        tasks[_taskId].worker.transfer(tasks[_taskId].reward); 
    }

    function getTask(uint _taskId) public view returns (string memory, uint, bool, bool) {
        require(_taskId < tasks.length, "There is no such task.");

        Task memory task = tasks[_taskId];
        return (task.description, task.reward, task.isTaken, task.isCompleted);
    }
}
