1 pragma solidity ^0.4.16;
2 
3 contract ERC20Token {
4     // these functions aren't abstract since the compiler emits automatically generated getter functions as external
5     function name() public pure returns (string) {}
6     function symbol() public pure returns (string) {}
7     function decimals() public pure returns (uint8) {}
8     function totalSupply() public pure returns (uint256) {}
9     function balanceOf(address _owner) public pure returns (uint256) { _owner; }
10     function allowance(address _owner, address _spender) public pure returns (uint256) { _owner; _spender; }
11 
12     function transfer(address _to, uint256 _value) public returns (bool success);
13     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
14     function approve(address _spender, uint256 _value) public returns (bool success);
15 }
16 
17 contract CommonWallet {
18     mapping(address => mapping (address => uint256)) public tokenBalance;
19     mapping(address => uint) etherBalance;
20     address owner = msg.sender;
21     
22     function safeAdd(uint256 _x, uint256 _y) internal pure returns (uint256) {
23         uint256 z = _x + _y;
24         assert(z >= _x);
25         return z;
26     }
27 
28     function safeSub(uint256 _x, uint256 _y) internal pure returns (uint256) {
29         assert(_x >= _y);
30         return _x - _y;
31     }
32     
33     function depoEther() public payable{
34         etherBalance[msg.sender]+=msg.value;
35     }
36     
37     function depoToken(address tokenAddr, uint256 amount) public {
38         if (ERC20Token(tokenAddr).transferFrom(msg.sender, this, amount))
39         {
40             tokenBalance[tokenAddr][msg.sender] = safeAdd(tokenBalance[tokenAddr][msg.sender], amount);
41         }
42     }
43   
44     function wdEther(uint amount) public{
45         require(etherBalance[msg.sender]>=amount);
46         address sender=msg.sender;
47         sender.transfer(amount);
48         etherBalance[sender] = safeSub(etherBalance[sender],amount);
49     }
50     
51     function wdToken(address tokenAddr, uint256 amount) public {
52         require(tokenBalance[tokenAddr][msg.sender] < amount);
53         if(ERC20Token(tokenAddr).transfer(msg.sender, amount))
54         {
55             tokenBalance[tokenAddr][msg.sender] = safeSub(tokenBalance[tokenAddr][msg.sender], amount);
56         }
57     }
58   
59     function getEtherBalance(address user) public view returns(uint256) {
60         return etherBalance[user];
61     }
62     
63     function getTokenBalance(address tokenAddr, address user) public view returns (uint256) {
64         return tokenBalance[tokenAddr][user];
65     }
66     
67     function sendEtherTo(address to_, uint amount) public {
68         require(etherBalance[msg.sender]>=amount);
69         require(to_!=msg.sender);
70         to_.transfer(amount);
71         etherBalance[msg.sender] = safeSub(etherBalance[msg.sender],amount);
72     }
73     
74     function sendTokenTo(address tokenAddr, address to_, uint256 amount) public {
75         require(tokenBalance[tokenAddr][msg.sender] < amount);
76         require(!ERC20Token(tokenAddr).transfer(to_, amount));
77         tokenBalance[tokenAddr][msg.sender] = safeSub(tokenBalance[tokenAddr][msg.sender], amount);
78     }
79 }