1 pragma solidity ^0.4.18;
2 
3 contract ERC20Basic {
4   uint256 public totalSupply;
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 contract ERC20 is ERC20Basic {
11   function allowance(address owner, address spender) public view returns (uint256);
12   function transferFrom(address from, address to, uint256 value) public returns (bool);
13   function approve(address spender, uint256 value) public returns (bool);
14   event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 contract Airdrop {
18     ERC20 public token;
19     
20     event LogAccountAmount(address indexed user, uint256 indexed amount);
21 
22     function Airdrop(address _token) public {
23         token = ERC20(_token);
24     }
25 
26     function setToken(address _token) public {
27         token = ERC20(_token);
28     }
29 
30     // Uses transferFrom so you'll need to approve some tokens before this one to
31     // this contract address
32     function startAirdrop(address[] users, uint256[] amounts) public {
33         for(uint256 i = 0; i < users.length; i++) {
34             address account = users[i];
35             uint256 amount = amounts[i];
36             
37             LogAccountAmount(account, amount);
38             
39             token.transfer(account, amount);
40         }
41     }
42     
43     function recoverTokens(address _user, uint256 _amount) public {
44         token.transfer(_user, _amount);
45     }
46 }