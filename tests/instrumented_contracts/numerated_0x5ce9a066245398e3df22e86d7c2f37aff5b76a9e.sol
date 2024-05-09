1 pragma solidity ^0.4.24;
2 
3 interface IERC20 {
4   function totalSupply() external view returns (uint256);
5 
6   function balanceOf(address who) external view returns (uint256);
7 
8   function allowance(address owner, address spender)
9     external view returns (uint256);
10 
11   function transfer(address to, uint256 value) external returns (bool);
12 
13   function approve(address spender, uint256 value)
14     external returns (bool);
15 
16   function transferFrom(address from, address to, uint256 value)
17     external returns (bool);
18 
19   event Transfer(
20     address indexed from,
21     address indexed to,
22     uint256 value
23   );
24 
25   event Approval(
26     address indexed owner,
27     address indexed spender,
28     uint256 value
29   );
30 }
31 
32 contract  CheckErc20 { 
33 
34     mapping(address=>string) public erc20Map;
35     address[] public erc20Array;
36     address owner;
37     constructor () public{
38         owner = msg.sender;
39     }
40 
41     function getBalance() public view returns (uint[]){
42         return this.getBalance(msg.sender);
43     }  
44 
45     function getBalance(address addr) public view returns (uint[]){
46         uint erc20Length = erc20Array.length;
47         uint[] memory balances;
48         for(uint i = 0;i<erc20Length;i++){
49             IERC20 erc20Contract = IERC20(erc20Array[i]);
50             uint erc20Balance = erc20Contract.balanceOf(addr);
51             balances[i] = erc20Balance;
52         }
53         return balances;
54     }
55 
56     function addErc20 (address erc20address, string erc20Name) public {
57         require(msg.sender==owner, "need owner");
58         erc20Array.push(erc20address);
59         erc20Map[erc20address] = erc20Name;
60     }
61 }