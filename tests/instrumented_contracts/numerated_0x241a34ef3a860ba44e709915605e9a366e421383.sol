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
17 contract AirdropFinal {
18     ERC20 public token;
19     address public creator;
20 
21         modifier isCreator() {
22         require(msg.sender == creator);
23         // if (msg.sender != creator) throw;
24         _;
25     }
26     
27     event LogAccountAmount(address indexed user, uint256 indexed amount);
28 
29     function AirdropFinal(address _token) public {
30         token = ERC20(_token);
31         creator = msg.sender;
32     }
33 
34     function setToken(address _token) public {
35         token = ERC20(_token);
36     }
37 
38     // Uses transferFrom so you'll need to approve some tokens before this one to
39     // this contract address
40     function startAirdrop(address[] users, uint256 amounts) public {
41         for(uint256 i = 0; i < users.length; i++) {
42             address account = users[i];
43             uint256 amount = amounts;
44             
45             LogAccountAmount(account, amount);
46             
47             token.transfer(account, amount);
48         }
49     }
50     
51     function recoverTokens(address _user, uint256 _amount) public {
52         token.transfer(_user, _amount);
53     }
54     function removeContract() public isCreator()
55         {
56             selfdestruct(msg.sender);
57             
58         }
59 }