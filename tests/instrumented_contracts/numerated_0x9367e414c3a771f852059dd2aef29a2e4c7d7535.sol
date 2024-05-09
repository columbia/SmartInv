1 pragma solidity ^0.5.1;
2 
3 contract ERC20Interface {
4     function totalSupply() public view returns (uint256);
5     function balanceOf(address tokenOwner) public view returns (uint256 balance);
6     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
7     function transfer(address to, uint256 tokens) public returns (bool success);
8     function approve(address spender, uint256 tokens) public returns (bool success);
9     function transferFrom(address from, address to, uint256 tokens) public returns (bool success);
10     function rise() public returns (bool success);
11 
12     event Transfer(address indexed from, address indexed to, uint256 tokens);
13     event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);
14 }
15 
16 
17 contract ERC20Proxy {
18     function totalSupply() public view returns (uint256);
19     function balanceOf(address tokenOwner) public view returns (uint256 balance);
20     function allowance(address tokenOwner, address spender) public view returns (uint256 remaining);
21     function transfer(address sender, address to, uint256 tokens) public returns (bool success);
22     function approve(address sender, address spender, uint256 tokens) public returns (bool success);
23     function transferFrom(address sender, address from, address to, uint256 tokens) public returns (bool success);
24     function rise(address to) public returns (bool success);
25 }
26 
27 contract SlaveEmitter {
28     function emitTransfer(address _from, address _to, uint256 _value) public;
29     function rememberMe(ERC20Proxy _multiAsset) public returns(bool success) ;
30     function emitApprove(address _from, address _spender, uint256 _value) public;
31     function emitTransfers(address _from, address[] memory dests, uint256[] memory values) public;
32 }
33 
34 contract TorrentShares is ERC20Interface, SlaveEmitter {
35 
36     constructor() public {
37         owner = msg.sender;
38     }
39 
40     string public name = "Torrent Shares";
41     string public symbol = "TOR";
42     uint256 public decimals = 18;
43 
44     ERC20Proxy master = ERC20Proxy(address(0x0));
45     address owner;
46 
47     modifier onlyMaster {
48         assert( msg.sender == address(master) || msg.sender == owner);
49         _;
50     }
51 
52     function emitTransfer(address _from, address _to, uint256 _value) public onlyMaster() {
53         emit Transfer(_from, _to, _value);
54     }
55 
56     function transfer(address _to, uint256 _tokens) public returns (bool success) {
57         return master.transfer(msg.sender, _to, _tokens);
58     }
59 
60     function totalSupply() public view returns(uint256) {
61         return master.totalSupply();
62     }
63 
64     function rememberMe(ERC20Proxy _master) public returns(bool success) {
65         require(msg.sender == owner || master == ERC20Proxy(0x0));
66         master = _master;
67         return true;
68     }
69 
70     function allowance(address _from, address _spender) public view returns(uint256) {
71         return master.allowance(_from, _spender);
72     }
73 
74 
75     function approve(address _spender, uint256 _tokens) public returns (bool success) {
76         return master.approve(msg.sender, _spender, _tokens);
77     }
78 
79     function transferFrom(address _from, address _to, uint256 _tokens) public returns (bool success) {
80         return master.transferFrom(msg.sender, _from, _to, _tokens);
81     }
82 
83     function balanceOf(address _owner) public view returns(uint256) {
84         return master.balanceOf(_owner);
85     }
86 
87 
88     function emitApprove(address _from, address _spender, uint256 _value) public onlyMaster() {
89         emit Approval(_from, _spender, _value);
90     }
91 
92     function emitTransfers(address _from, address[] memory dests, uint256[] memory values) public onlyMaster() {
93         for (uint i = 0; i < values.length; i++)
94             emit Transfer(_from, dests[i], values[i]);
95     }
96 
97     function () external payable {
98         revert();
99     }
100 
101     function rise() public onlyMaster() returns (bool success) {
102         return master.rise(msg.sender);
103     }
104 
105     function transferAnyERC20Token(address tokenAddress, uint tokens) public onlyMaster() returns (bool success) {
106         return ERC20Interface(tokenAddress).transfer(owner, tokens);
107     }
108 }