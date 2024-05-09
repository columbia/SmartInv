1 pragma solidity ^0.4.24;
2 contract ERC20 {
3     uint public totalSupply;
4     function balanceOf(address _owner) constant public returns (uint balance);
5     function transfer(address _to, uint _value) public returns (bool success);
6     function transferFrom(address _from, address _to, uint _value) public returns (bool success);
7     function approve(address _spender, uint _value) public returns (bool success);
8     function allowance(address _owner, address _spender) public constant returns (uint remaining);
9     event Transfer(address indexed from, address indexed to, uint value);
10     event Approval(address indexed owner, address indexed spender, uint value);
11 }
12 
13 contract Airdropper
14 {
15   function multisend(address _tokenAddr, address[] addr, uint256[] values) public
16   {
17     require(addr.length == values.length && addr.length > 0);
18     uint256 i=0;
19     while(i < addr.length)
20     {
21       require(addr[i] != address(0));
22       require(values[i] > 0);
23       require(ERC20(_tokenAddr).transferFrom(msg.sender, addr[i], values[i]));
24       i++;
25     }
26   }
27 }