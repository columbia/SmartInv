1 pragma solidity ^0.4.18;
2     library SafeMath {
3         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
4             uint256 c = a * b;
5             assert(a == 0 || c / a == b);
6             return c;
7         }
8     
9         function div(uint256 a, uint256 b) internal pure returns (uint256) {
10             // assert(b > 0); // Solidity automatically throws when dividing by 0
11             uint256 c = a / b;
12             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
13             return c;
14         }
15     
16         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
17             assert(b <= a);
18             return a - b;
19         }
20     
21         function add(uint256 a, uint256 b) internal pure returns (uint256) {
22             uint256 c = a + b;
23             assert(c >= a);
24             return c;
25         }
26     }
27     library ERC20Interface {
28         function totalSupply() public constant returns (uint);
29         function balanceOf(address tokenOwner) public constant returns (uint balance);
30         function allowance(address tokenOwner, address spender) public constant returns (uint remaining);
31         function transfer(address to, uint tokens) public returns (bool success);
32         function approve(address spender, uint tokens) public returns (bool success);
33         function transferFrom(address from, address to, uint tokens) public returns (bool success);
34         event Transfer(address indexed from, address indexed to, uint tokens);
35         event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
36     }
37     library ApproveAndCallFallBack {
38         function receiveApproval(address from, uint256 tokens, address token, bytes data) public;
39     }
40     contract owned {
41     
42     
43     	    address public owner;
44     
45     
46     	    function owned() payable public {
47     	        owner = msg.sender;
48     	    }
49     	    
50     	    modifier onlyOwner {
51     	        require(owner == msg.sender);
52     	        _;
53     	    }
54     
55     
56     	    function changeOwner(address _owner) onlyOwner public {
57     	        owner = _owner;
58     	    }
59     	}
60     contract Crowdsale is owned {
61     	    
62     	    uint256 public totalSupply;
63     	
64     	    mapping (address => uint256) public balanceOf;
65     
66     
67     	    event Transfer(address indexed from, address indexed to, uint256 value);
68     	    
69     	    function Crowdsale() payable owned() public {
70                 totalSupply = 1000000000 * 1000000000000000000; 
71                 // ico
72     	        balanceOf[this] = 900000000 * 1000000000000000000;   
73     	        balanceOf[owner] = totalSupply - balanceOf[this];
74     	        Transfer(this, owner, balanceOf[owner]);
75     	    }
76     
77     	    function () payable public {
78     	        require(balanceOf[this] > 0);
79     	        
80     	        uint256 tokensPerOneEther = 1111 * 1000000000000000000;
81     	        uint256 tokens = tokensPerOneEther * msg.value / 1000000000000000000;
82     	        if (tokens > balanceOf[this]) {
83     	            tokens = balanceOf[this];
84     	            uint valueWei = tokens * 1000000000000000000 / tokensPerOneEther;
85     	            msg.sender.transfer(msg.value - valueWei);
86     	        }
87     	        require(tokens > 0);
88     	        balanceOf[msg.sender] += tokens;
89     	        balanceOf[this] -= tokens;
90     	        Transfer(this, msg.sender, tokens);
91     	    }
92     	}
93     contract NEURAL is Crowdsale {
94         
95             using SafeMath for uint256;
96             string  public name        = 'NEURAL';
97     	    string  public symbol      = 'NEURAL';
98     	    string  public standard    = 'NEURAL.CLUB';
99             
100     	    uint8   public decimals    = 18;
101     	    mapping (address => mapping (address => uint256)) internal allowed;
102     	    
103     	    function NEURAL() payable Crowdsale() public {}
104     	    
105     	    function transfer(address _to, uint256 _value) public {
106     	        require(balanceOf[msg.sender] >= _value);
107     	        balanceOf[msg.sender] -= _value;
108     	        balanceOf[_to] += _value;
109     	        Transfer(msg.sender, _to, _value);
110     	    }
111     	}
112     contract NeuralControl is NEURAL {
113     	    function NeuralControl() payable NEURAL() public {}
114     	    function withdraw() onlyOwner {    
115     	        owner.transfer(this.balance);  
116     	    }
117     	    function killMe()  onlyOwner {
118     	        selfdestruct(owner);
119     	    }
120     	}