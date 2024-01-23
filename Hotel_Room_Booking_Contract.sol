// SPDX-License-Identifier: MIT
pragma solidity >=0.4.0 < 0.9.0;

contract HotelRoom {

    // Declare an enum to represent the two possible states of the hotel room
    enum Statuses { 
        Vacant, 
        Occupied 
    }

    // Declare a state variable to store the current status of the hotel room
    Statuses public currentStatus;

    // Declare an event to be emitted when the hotel room is occupied
    event Occupy(address _occupant, uint _value);

    // Declare the owner of the hotel room contract
    address payable public owner;

    // The constructor is called when the contract is deployed
    constructor() {
        owner = payable(msg.sender);
        currentStatus = Statuses.Vacant;
    }

    // The onlyWhileVacant modifier checks if the hotel room is vacant before executing the function
    modifier onlyWhileVacant{
        require(currentStatus == Statuses.Vacant, "Currently Occupied.");
        _;
    }

    // The costs modifier checks if the required amount of ether is provided before executing the function
    modifier costs(uint _amount){
        require(msg.value >= _amount, "Not enough ether provided.");
        _;
    }

    // A function to get the current status of the hotel room
    function getCurrentStatus() public view returns (string memory) {
        if (currentStatus == Statuses.Vacant) {
            return "Vacant";
        } else {
            return "Occupied";
        }
    }

    // The book function allows a user to book the hotel room if it is vacant and they provide at least 2 ether as a payment
    function book() payable public onlyWhileVacant costs(2 ether) {
    currentStatus = Statuses.Occupied;
    owner.transfer(msg.value);

    emit Occupy(msg.sender, msg.value);
}
}
