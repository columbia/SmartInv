1 //  █████████   ▄████      ███  ███▄      ███      ▄████               ▄████      ███
2 //  ███▀▀▀▀▀   ▄██████     ███  █████   ▄████▌    ▄██████             ▄██████     ███
3 //  ████████  ▄███ ▀███    ███  ██████ ██████▌   ▄███  ███           ▄███  ███    ███
4 //  ███▀▀▀▀▀  ██████████   ███  ███▌█████ ███▌   ██████████         ▄██████████   ███
5 //  ███      ███▀    ████  ███  ███  ▀█▀  ███▌  ███▀    ████  ██   ▄███▀    ████  ███
6 //
7 //
8 // Congratulations! Its your free airdrop token.
9 // Get ready to participate in token sale www.faima.ai 
10 // Pre-ICO starts on 1.03.2018
11 // Private SALE IS OPEN now
12 // 1BTC=20000$+bonus
13 // 1ETH=2000$+bonus
14 // for booking: ceo@faima.ai
15 
16 pragma solidity 0.4.18;
17 
18 contract Ownable {
19     address public owner;
20 
21     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
22 
23     modifier onlyOwner() { require(msg.sender == owner); _; }
24 
25     function Ownable() public {
26         owner = msg.sender;
27     }
28 
29     function transferOwnership(address newOwner) public onlyOwner {
30         require(newOwner != address(0));
31         owner = newOwner;
32         OwnershipTransferred(owner, newOwner);
33     }
34 }
35 
36 contract Withdrawable is Ownable {
37     function withdrawEther(address _to, uint _value) onlyOwner public returns(bool) {
38         require(_to != address(0));
39         require(this.balance >= _value);
40 
41         _to.transfer(_value);
42 
43         return true;
44     }
45 
46     function withdrawTokens(ERC20 _token, address _to, uint _value) onlyOwner public returns(bool) {
47         require(_to != address(0));
48 
49         return _token.transfer(_to, _value);
50     }
51 }
52 
53 contract ERC20 {
54     uint256 public totalSupply;
55 
56     event Transfer(address indexed from, address indexed to, uint256 value);
57     event Approval(address indexed owner, address indexed spender, uint256 value);
58 
59     function balanceOf(address who) public view returns(uint256);
60     function transfer(address to, uint256 value) public returns(bool);
61     function transferFrom(address from, address to, uint256 value) public returns(bool);
62     function allowance(address owner, address spender) public view returns(uint256);
63     function approve(address spender, uint256 value) public returns(bool);
64 }
65 
66 contract AirDrop is Withdrawable {
67     event TransferEther(address indexed to, uint256 value);
68 
69     function tokenBalanceOf(ERC20 _token) public view returns(uint256) {
70         return _token.balanceOf(this);
71     }
72 
73     function tokenAllowance(ERC20 _token, address spender) public view returns(uint256) {
74         return _token.allowance(this, spender);
75     }
76     
77     function tokenTransfer(ERC20 _token, uint _value, address[] _to) onlyOwner public {
78         require(_token != address(0));
79 
80         for(uint i = 0; i < _to.length; i++) {
81             require(_token.transfer(_to[i], _value));
82         }
83     }
84     
85     function tokenTransferFrom(ERC20 _token, address spender, uint _value, address[] _to) onlyOwner public {
86         require(_token != address(0));
87 
88         for(uint i = 0; i < _to.length; i++) {
89             require(_token.transferFrom(spender, _to[i], _value));
90         }
91     }
92 
93     function etherTransfer(uint _value, address[] _to) onlyOwner payable public {
94         for(uint i = 0; i < _to.length; i++) {
95             _to[i].transfer(_value);
96             TransferEther(_to[i], _value);
97         }
98     }
99 }