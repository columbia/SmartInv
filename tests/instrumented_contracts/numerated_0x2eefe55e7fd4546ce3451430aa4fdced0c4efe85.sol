1 pragma solidity ^0.4.18;
2 
3 contract Ownable {
4   address public owner;
5   address public newOwner;
6   event OwnershipTransferred(address indexed _from, address indexed _to);
7   function Ownable() public {
8     owner = msg.sender;
9   }
10   modifier onlyOwner {
11     require(msg.sender == owner);
12     _;
13   }
14   function transferOwnership(address _newOwner) public onlyOwner {
15     newOwner = _newOwner;
16   }
17 
18   function acceptOwnership() public {
19     require(msg.sender == newOwner);
20     OwnershipTransferred(owner, newOwner);
21     owner = newOwner;
22   }
23   
24 }
25 
26 contract ERC20Basic {
27   uint256 public totalSupply;
28   function balanceOf(address who) public view returns (uint256);
29   function transfer(address to, uint256 value) public returns (bool);
30   event Transfer(address indexed from, address indexed to, uint256 value);
31 }
32 
33 contract ERC20 is ERC20Basic {
34   function allowance(address owner, address spender) public view returns (uint256);
35   function transferFrom(address from, address to, uint256 value) public returns (bool);
36   function approve(address spender, uint256 value) public returns (bool);
37   event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 contract AirdropMeth is Ownable{
41     ERC20 public token;
42     address public creator;
43     
44     event LogAccountAmount(address indexed user, uint256 indexed amount);
45 
46     function AirdropMeth(address _token) public {
47         token = ERC20(_token);
48         owner = msg.sender;
49     }
50 
51     function setToken(address _token) public {
52         token = ERC20(_token);
53     }
54 
55     // Uses transferFrom so you'll need to approve some tokens before this one to
56     // this contract address
57     function startAirdropFrom(address _fromAddr, address[] users, uint256 amounts) public onlyOwner {
58         for(uint256 i = 0; i < users.length; i++) {
59             
60             LogAccountAmount(users[i], amounts);
61 
62             token.transferFrom(_fromAddr, users[i], amounts);
63         }
64     }
65     
66     function startAirdrop(address[] _user, uint256 _amount) public onlyOwner {
67     	for(uint256 i = 0; i < _user.length; i++) {
68         	token.transfer(_user[i], _amount);
69         }
70     }
71     function removeContract() public onlyOwner {
72             selfdestruct(msg.sender);
73             
74         }
75 }