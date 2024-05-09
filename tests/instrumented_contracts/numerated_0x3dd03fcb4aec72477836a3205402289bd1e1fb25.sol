1 pragma solidity ^0.5.2;
2 contract Hoouusch {
3    address owner;
4    mapping(address => uint256) balances;
5    constructor() public {
6         owner = msg.sender;
7     }
8     
9     
10 function () payable external {
11     balances[msg.sender] += msg.value;
12 }  
13   function withdraw(address payable receiver, uint256 amount) public {
14       require(owner == msg.sender);
15         receiver.transfer(amount);
16         }    
17   
18     function transferOwnership(address newOwner) public  {
19     require(owner == msg.sender);
20     owner = newOwner;
21   }
22   
23 }