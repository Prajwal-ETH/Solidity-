// SPDX-License-Identifier: MIT
pragma solidity >0.4.0 <= 0.9.0;

import "https://github.com/ConsenSysMesh/openzeppelin-solidity/blob/master/contracts/math/SafeMath.sol";

contract RealEstate {
    using SafeMath for uint256;

    // Structure to represent a real estate property
    struct Property {
        uint256 price;      // Price of the property
        address owner;      // Current owner's Ethereum address
        bool forSale;       // Flag indicating whether the property is for sale
        string name;        // Name of the property
        string description; // Description of the property
        string location;    // Location of the property
    }

    // Mapping to store properties using their unique IDs
    mapping(uint256 => Property) public properties;

    // Array to store the IDs of all listed properties
    uint256[] public propertyIds;

    // Event triggered when a property is sold
    event PropertySold(uint256 propertyId);

    // Function to list a property for sale
    function listPropertyForSale(
        uint256 _propertyId,
        uint256 _price,
        string memory _name,
        string memory _description,
        string memory _location
    ) public {
        // Creating a new Property instance with provided details
        Property memory newProperty = Property({
            price: _price,
            owner: msg.sender,  // The person calling the function becomes the initial owner
            forSale: true,
            name: _name,
            description: _description,
            location: _location
        });

        // Adding the new property to the mapping using its ID
        properties[_propertyId] = newProperty;

        // Adding the property ID to the array of all property IDs
        propertyIds.push(_propertyId);
    }

    // Function to buy a property
    function buyProperty(uint256 _propertyId) public payable {
        // Retrieving the property to be bought from the mapping
        Property storage property = properties[_propertyId];

        // Checking if the property is listed for sale
        require(property.forSale, "Property is not for sale");

        // Checking if the sent Ether is equal to or more than the property price
        require(property.price <= msg.value, "Insufficient funds");

        // Changing ownership and updating the forSale flag
        property.owner = msg.sender;
        property.forSale = false;

        // Transferring the funds to the previous owner
        address(uint256(property.owner)).transfer(property.price);

        // Triggering the PropertySold event
        emit PropertySold(_propertyId);
    }
}
