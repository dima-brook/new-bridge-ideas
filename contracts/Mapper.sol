// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Mapper {

    struct Record {
        // String is preferable over address
        // to support Non-EVM addresses
        string target;
        bool keepId;
        // TODO: add optional array of tokenIds
    }

    mapping(address => mapping(uint16 => Record)) _map;

    address private admin;

    modifier onlyAdmin {
        require(msg.sender == admin, "Unauthorised function call");
        _;
    }

    event UpdateMap(address origin, uint16 chainId, string target, bool keepId);

    event DeleteMap(address origin, uint16 chainId);

    constructor(){
        admin = msg.sender;
    }

    function setMap (address _origin, uint16 _chainId, string memory _target, bool _keepId) public onlyAdmin {

        _map[_origin][_chainId] = Record(_target, _keepId);

        emit UpdateMap(_origin, _chainId, _target, _keepId);
    }

    function deleteMap (address _origin, uint16 _chainId) public onlyAdmin {

        require(_exists(_origin, _chainId), "Mapping does not exist for this contract");

        _map[_origin][_chainId] = Record("", false);

        emit DeleteMap(_origin, _chainId);
    }

    function readMap (address _origin, uint16 _chainId) public view returns (string memory) {

        require(_exists(_origin, _chainId), "Mapping does not exist for this contract");

        return _map[_origin][_chainId].target;
    }

    function _exists(address _origin, uint16 _chainId) internal view returns (bool){

        if(bytes(_map[_origin][_chainId].target).length > 0){
            return true;
        }
        return false;
    }

}