1 pragma solidity ^0.4.18;
2 
3 contract Notifier {
4   function name() public view returns (string) {
5     return "Notifier";
6   }
7   function symbol() public view returns (string){
8      return "NT";  
9   }
10   function decimals() view returns (uint8 ){
11       return  8;
12   }
13   function totalSupply() public view returns (uint256){
14       return 10000000000;
15   }
16   function balanceOf(address who) public view returns (uint256){
17       return 0;
18   }
19   function transfer(address to, uint256 value) public returns (bool){
20       emit Transfer(msg.sender, to, value);
21       return true;
22   }
23   function transferFrom(address from, address to, uint256 value) public returns (bool){
24       emit Transfer(from, to, value);
25        return true;
26   }
27   function approve(address spender, uint256 value) public returns (bool){
28       emit Approval(msg.sender,spender,value);
29        return true;
30   }
31   function allowance(address owner, address spender) public view returns (uint256){
32        return 0;
33   }
34   event Approval(address indexed owner, address indexed spender, uint256 value);
35   event Transfer(address indexed from, address indexed to, uint256 value);
36   constructor () public {}
37 }