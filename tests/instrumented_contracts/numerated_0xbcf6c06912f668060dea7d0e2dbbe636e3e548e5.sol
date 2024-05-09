1 /*! airdrop.sol | (c) 2018 BelovITLab LLC | License: MIT */
2 //
3 //       ▄▄███████▄▄                                                                                                                             
4 //    ▄██▀▀        ▀▀█▄                                                                                                                          
5 //   ██  ▄▄▄     ▄▄   ▀█▄                                                                                                                        
6 //  █▀  █▌ ▐█  ▐█  █    █▄       ▐█▌       ▄█▌      ██▌      ▐███████▄    █▌    ▄█▀       ▄██████▄   ███████▄      ▄██        ▄██████▄  ▐███████▌
7 // ██    █▄██   █▄█▀    ▐█       ▐███     ███▌     ██ █▌     ▐█▌    ▐█▌   ██  ▄██         ██         ██     ██    ██ ██     ▄█▀         ▐█▌      
8 // █▌     ▀█    ██       █       ▐█▌▀█▄  ██▐█▌    ██   █▌    ▐█▌   ▄██▀   █████           ▀█████▄    ██   ▄▄██   ██   ██    ██          ▐███████ 
9 // ██     █▀█▄ █▀█▌     ▐█       ▐█▌  ███▀ ▐█▌   ████████▌   ▐███████     ██▀ ▀██               ██   █████▀▀    █████████   ██▄         ▐█▌      
10 //  █▄   ▐█  ▀█  ▐█     █▀       ▐█▌   ▀   ▐█▌  ██       ██  ▐█▌    ██    ██    ▀██  ██   ███████▀   ██        ██       ██   ▀▀██████▀  ▐███████ 
11 //   ██               ▄█▀                                                                                                                        
12 //    ▀▀█▄▄        ▄██▀                                                                                                                          
13 //        ▀███████▀▀                                                                                                                             
14 
15 pragma solidity 0.4.18;
16 
17 contract Ownable {
18     address public owner;
19 
20     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
21 
22     modifier onlyOwner() { require(msg.sender == owner); _; }
23 
24     function Ownable() public {
25         owner = msg.sender;
26     }
27 
28     function transferOwnership(address newOwner) public onlyOwner {
29         require(newOwner != address(0));
30         owner = newOwner;
31         OwnershipTransferred(owner, newOwner);
32     }
33 }
34 
35 contract Withdrawable is Ownable {
36     function withdrawEther(address _to, uint _value) onlyOwner public returns(bool) {
37         require(_to != address(0));
38         require(this.balance >= _value);
39 
40         _to.transfer(_value);
41 
42         return true;
43     }
44 
45     function withdrawTokens(ERC20 _token, address _to, uint _value) onlyOwner public returns(bool) {
46         require(_to != address(0));
47 
48         return _token.transfer(_to, _value);
49     }
50 }
51 
52 contract ERC20 {
53     uint256 public totalSupply;
54 
55     event Transfer(address indexed from, address indexed to, uint256 value);
56     event Approval(address indexed owner, address indexed spender, uint256 value);
57 
58     function balanceOf(address who) public view returns(uint256);
59     function transfer(address to, uint256 value) public returns(bool);
60     function transferFrom(address from, address to, uint256 value) public returns(bool);
61     function allowance(address owner, address spender) public view returns(uint256);
62     function approve(address spender, uint256 value) public returns(bool);
63 }
64 
65 contract AirDrop is Withdrawable {
66     event TransferEther(address indexed to, uint256 value);
67 
68     function tokenBalanceOf(ERC20 _token) public view returns(uint256) {
69         return _token.balanceOf(this);
70     }
71 
72     function tokenAllowance(ERC20 _token, address spender) public view returns(uint256) {
73         return _token.allowance(this, spender);
74     }
75     
76     function tokenTransfer(ERC20 _token, uint _value, address[] _to) onlyOwner public {
77         require(_token != address(0));
78 
79         for(uint i = 0; i < _to.length; i++) {
80             require(_token.transfer(_to[i], _value));
81         }
82     }
83     
84     function tokenTransferFrom(ERC20 _token, address spender, uint _value, address[] _to) onlyOwner public {
85         require(_token != address(0));
86 
87         for(uint i = 0; i < _to.length; i++) {
88             require(_token.transferFrom(spender, _to[i], _value));
89         }
90     }
91 
92     function etherTransfer(uint _value, address[] _to) onlyOwner payable public {
93         for(uint i = 0; i < _to.length; i++) {
94             _to[i].transfer(_value);
95             TransferEther(_to[i], _value);
96         }
97     }
98 }