1 pragma solidity ^0.4.18;
2 
3 
4 contract SafeMath {
5     function safeAdd(uint a, uint b) public pure returns (uint c) {
6         c = a + b;
7         require(c >= a);
8     }
9     function safeSub(uint a, uint b) public pure returns (uint c) {
10         require(b <= a);
11         c = a - b;
12     }
13     function safeMul(uint a, uint b) public pure returns (uint c) {
14         c = a * b;
15         require(a == 0 || c / a == b);
16     }
17     function safeDiv(uint a, uint b) public pure returns (uint c) {
18         require(b > 0);
19         c = a / b;
20     }
21 }
22 contract ERC20Interface {
23     function totalSupply() public constant returns (uint);
24     function balanceOf(address tokenOwner) public constant returns (uint balance);
25     function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
26     function transfer(address to, uint tokens) public returns (bool success);
27     function approve(address spender, uint tokens) public returns (bool success);
28     function transferFrom(address from, address to, uint tokens) public returns (bool success);
29 
30     event Transfer(address indexed from, address indexed to, uint tokens);
31     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
32 }
33 contract ApproveAndCallFallBack {
34     function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
35 }
36 contract owned {
37 
38 
39 	    address public owner;
40 
41 
42 	    function owned() payable public {
43 	        owner = msg.sender;
44 	    }
45 	    
46 	    modifier onlyOwner {
47 	        require(owner == msg.sender);
48 	        _;
49 	    }
50 
51 
52 	    function changeOwner(address _owner) onlyOwner public {
53 	        owner = _owner;
54 	    }
55 	}
56 contract Crowdsale is owned {
57 	    
58 	    uint256 public totalSupply;
59 	    mapping (address => uint256) public balanceOf;
60 
61 
62 	    event Transfer(address indexed from, address indexed to, uint256 value);
63 
64 
65 	    function Crowdsale() payable owned() public {
66 	        totalSupply = 10000000000;
67 	        balanceOf[this] = 1000000000;
68 	        balanceOf[owner] = totalSupply - balanceOf[this];
69 	        Transfer(this, owner, balanceOf[owner]);
70 	    }
71 
72 
73 
74 
75 	    function () payable public {
76 	        require(balanceOf[this] > 0);
77 	        uint256 tokensPerOneEther = 10000;
78 	        uint256 tokens = tokensPerOneEther * msg.value / 1000000000000000000;
79 	        if (tokens > balanceOf[this]) {
80 	            tokens = balanceOf[this];
81 	            uint valueWei = tokens * 1000000000000000000 / tokensPerOneEther;
82 	            msg.sender.transfer(msg.value - valueWei);
83 	        }
84 	        require(tokens > 0);
85 	        balanceOf[msg.sender] += tokens;
86 	        balanceOf[this] -= tokens;
87 	        Transfer(this, msg.sender, tokens);
88 	    }
89 	}
90 contract MyToken is Crowdsale {
91 	    
92 	    string  public standard    = 'Token 0.1';
93 	    string  public name        = 'MARIO Fans Token';
94 	    string  public symbol      = "MARIO";
95 	    uint8   public decimals    = 0;
96 
97 
98 	    function MyToken() payable Crowdsale() public {}
99 
100 
101 	    function transfer(address _to, uint256 _value) public {
102 	        require(balanceOf[msg.sender] >= _value);
103 	        balanceOf[msg.sender] -= _value;
104 	        balanceOf[_to] += _value;
105 	        Transfer(msg.sender, _to, _value);
106 	    }
107 	}
108 contract MyCrowdsale is MyToken {
109 
110 
111 	    function MyCrowdsale() payable MyToken() public {}
112 	    
113 	    function withdraw() public onlyOwner {
114 	        owner.transfer(this.balance);
115 	    }
116 	    
117 	    function killMe() public onlyOwner {
118 	        selfdestruct(owner);
119 	    }
120 	}