//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Dating {
    string public name;
    uint256 public age;
    string public location;
    string[] public interests;

    constructor(
        string memory _name,
        uint256 _age,
        string memory _location,
        string[] memory _interests
    ) {
        name = _name;
        age = _age;
        location = _location;
        interests = _interests;
    }

    function getUserInfo()
        public
        view
        returns (string memory, uint256, string memory, string[] memory)
    {
        return (name, age, location, interests);
    }

    function getInterestsCount() public view returns (uint256) {
        return interests.length;
    }
}
