1 pragma solidity ^0.4.24;
2 
3 
4 // Based on https://medium.com/@ChrisLundkvist/exploring-simpler-ethereum-multisig-contracts-b71020c19037
5 contract MonteLabsMS {
6   uint public nonce;
7   // MonteLabs owners
8   mapping (address => bool) isOwner;
9 
10   constructor(address[] _owners) public {
11     require(_owners.length == 3);
12     for (uint i = 0; i < _owners.length; ++i) {
13       isOwner[_owners[i]] = true;
14     }
15   }
16 
17   function execute(uint8 _sigV, bytes32 _sigR, bytes32 _sigS, address _destination, uint _value, bytes _data) public {
18     require(isOwner[msg.sender]);
19     bytes memory prefix = "\x19Ethereum Signed Message:\n32";
20     bytes32 prefixedHash = keccak256(abi.encodePacked(prefix, keccak256(abi.encodePacked(this, _destination, _value, _data, nonce))));
21 
22     address recovered = ecrecover(prefixedHash, _sigV, _sigR, _sigS);
23     ++nonce;
24     require(_destination.call.value(_value)(_data));
25     require(recovered != msg.sender);
26     require(isOwner[recovered]);
27   }
28 
29   function() external payable {}
30 }