1 pragma solidity ^0.4.23;
2 
3 
4 contract EIP20Interface {
5 
6     uint256 public totalSupply;
7 
8 
9     function balanceOf(address _owner) public view returns (uint256 balance);
10 
11     function transfer(address _to, uint256 _value) public returns (bool success);
12 
13     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
14 
15     function approve(address _spender, uint256 _value) public returns (bool success);
16 
17     function allowance(address _owner, address _spender) public view returns (uint256 remaining);
18 
19     event Transfer(address indexed _from, address indexed _to, uint256 _value);
20     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
21 }
22 
23 library SafeMath {
24     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
25       // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
26       // benefit is lost if 'b' is also tested.
27       // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
28         if (a == 0) {
29             return 0;
30         }
31 
32         c = a * b;
33         assert(c / a == b);
34         return c;
35     }   
36 
37     /**
38     * @dev Integer division of two numbers, truncating the quotient.
39     */
40     function div(uint256 a, uint256 b) internal pure returns (uint256) {
41       // assert(b > 0); // Solidity automatically throws when dividing by 0
42       // uint256 c = a / b;
43       // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44         return a / b;
45     }
46 
47     /**
48     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49     */
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         assert(b <= a);
52         return a - b;
53     }
54 
55     /**
56     * @dev Adds two numbers, throws on overflow.
57     */
58     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
59         c = a + b;
60         assert(c >= a);
61         return c;
62     }
63 }
64 contract CommunicationCreatesValueToken is EIP20Interface {
65     using SafeMath for uint256;
66     string public name;
67     string public symbol;
68     uint8 public decimals;
69     uint256 public totalSupply;
70     
71     
72     mapping(address => uint256) public balanceOf;
73     mapping(address => uint256) public freezeOf;
74     mapping(address => mapping(address=> uint256)) allowed;
75 
76     /* This notifies clients about the amount burnt */
77     event Burn(address indexed from, uint256 value);
78 	
79 	/* This notifies clients about the amount frozen */
80     event Freeze(address indexed from, uint256 value);
81 	
82 	/* This notifies clients about the amount unfrozen */
83     event Unfreeze(address indexed from, uint256 value);
84 
85     constructor (
86         string _name,
87         string _symbol,
88         uint8 _decimals,
89         uint256 _totalSupply
90     ) public {
91         balanceOf[msg.sender] = _totalSupply;
92         name = _name;
93         symbol = _symbol;
94         decimals = _decimals;
95         totalSupply = _totalSupply;
96     }   
97     
98     function transfer(address _to, uint256 _value) public returns (bool success) {
99         require(balanceOf[msg.sender] >= _value);
100         require(_to != address(0));
101         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
102         balanceOf[_to] = balanceOf[_to].add(_value);
103         emit Transfer(msg.sender, _to, _value); 
104         return true;
105     }
106 
107     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
108         uint256 allowance = allowed[_from][msg.sender];
109         require(_to != address(0));
110         require(balanceOf[_from] >= _value && allowance >= _value);
111         balanceOf[_to] = balanceOf[_to].add(_value);
112         balanceOf[_from] = balanceOf[_from].sub(_value);
113         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
114         emit Transfer(_from, _to, _value); 
115         return true;
116     }
117 
118     function balanceOf(address _owner) public view returns (uint256 balance) {
119         return balanceOf[_owner];
120     }
121 
122     function approve(address _spender, uint256 _value) public returns (bool success) {
123         allowed[msg.sender][_spender] = _value;
124         emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
125         return true;
126     }
127 
128     function freeze(uint256 _value) public returns (bool success) {
129         require(balanceOf[msg.sender] >= _value);           // Check if the sender has enough
130         require(_value>0);
131         balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);                      // Subtract from the sender
132         freezeOf[msg.sender] = freezeOf[msg.sender].add(_value);                                // Updates totalSupply
133         emit Freeze(msg.sender, _value);
134         return true;
135     }
136 
137     function unfreeze(uint256 _value) public returns (bool success) {
138         require(freezeOf[msg.sender] >= _value);            // Check if the sender has enough
139 	    require(_value>0);
140         freezeOf[msg.sender] = freezeOf[msg.sender].sub(_value);                      // Subtract from the sender
141 		balanceOf[msg.sender] = balanceOf[msg.sender].add(_value);
142         emit Unfreeze(msg.sender, _value);
143         return true;
144     }
145 
146 
147     function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
148         return allowed[_owner][_spender];
149     }   
150 
151     /**
152     * @dev Burns a specific amount of tokens.
153     * @param _value The amount of token to be burned.
154     */
155     function burn(uint256 _value) public {
156         _burn(msg.sender, _value);
157     }
158 
159     function _burn(address _who, uint256 _value) internal {
160         require(_value <= balanceOf[_who]);
161         // no need to require value <= totalSupply, since that would imply the
162         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
163 
164         balanceOf[_who] = balanceOf[_who].sub(_value);
165         totalSupply = totalSupply.sub(_value);
166         emit Burn(_who, _value);
167         emit Transfer(_who, address(0), _value);
168     }
169 }