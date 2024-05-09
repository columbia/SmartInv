1 pragma solidity ^0.4.16;
2 /**
3  * @title SafeMath
4  * @dev Math operations with safety checks that throw on error
5  */
6 library SafeMath {
7     function mul(uint256 a, uint256 b) internal returns (uint256) {
8         if (a == 0) {
9             return 0;
10         }
11         uint256 c = a * b;
12         assert(c / a == b);
13         return c;
14     }
15     function div(uint256 a, uint256 b) internal returns (uint256) {
16         // assert(b > 0); // Solidity automatically throws when dividing by 0
17         uint256 c = a / b;
18         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
19         return c;
20     }
21     function sub(uint256 a, uint256 b) internal returns (uint256) {
22         assert(b <= a);
23         return a - b;
24     }
25     function add(uint256 a, uint256 b) internal returns (uint256) {
26         uint256 c = a + b;
27         assert(c >= a);
28         return c;
29     }
30 }
31 
32 
33 
34 contract EightCoin {
35     
36     using SafeMath for uint256;
37     
38     string public name = 'EightCoin';
39     string public symbol = '8CO';
40     uint public decimals = 8;
41     
42     address public owner;
43 
44     uint public totalSupply;
45     
46 
47     bool public mintingFinished = false;
48     
49 
50     mapping(address => uint256) balances;
51 
52     mapping(address => mapping (address => uint256)) allowed;
53      
54 
55     modifier onlyOwner() {
56         require(msg.sender != owner);
57         _;
58     }
59      
60 
61     function transferOwnership(address newOwner) public onlyOwner {
62         require(newOwner != address(0));
63         OwnershipTransferred(owner, newOwner);
64         owner = newOwner;
65     }
66      
67 
68     modifier canMint() {
69         require(!mintingFinished);
70         _;
71     }
72     
73 
74     function EightCoin() public {
75         uint _initialSupply = 120000000 * (10 ** uint256(decimals));
76     
77         balances[msg.sender] = _initialSupply;
78         totalSupply = _initialSupply;
79     }
80      
81     
82     function totalSupply()  public returns (uint256) {
83         return totalSupply;
84     }
85   
86     /**
87      * @dev Gets the balance of the specified address.
88      * @param _owner The address to query the the balance of.
89      * @return An uint256 representing the amount owned by the passed address.
90      */
91     function balanceOf(address _owner) public returns (uint256 balance) {
92         return balances[_owner];
93     }
94   
95     /**
96      * @dev transfer token for a specified address
97      * @param _to The address to transfer to.
98      * @param _value The amount to be transferred.
99      * 
100      */
101     function transfer(address _to, uint256 _value) returns (bool success) {
102         require(
103             balances[msg.sender] >= _value 
104             && _value > 0
105         ); 
106         balances[msg.sender] = balances[msg.sender].sub(_value);
107         balances[_to] = balances[_to].add(_value);
108         Transfer(msg.sender, _to, _value);
109         return true;
110     }
111   
112     /**
113      * @dev Transfer tokens from one address to another
114      * @param _from address The address which you want to send tokens from
115      * @param _to address The address which you want to transfer to
116      * @param _value uint256 the amount of tokens to be transferred
117      */
118     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
119         require(
120             balances[_from] >= _value
121             && allowed[_from][msg.sender] >= _value
122             && _value > 0
123         );
124         balances[_from] = balances[_from].sub(_value);
125         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
126         balances[_to] = balances[_to].add(_value);
127         Transfer(_from, _to, _value);
128         return true;
129     }
130   
131      /**
132      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
133      * Beware that changing an allowance with this method brings the risk that someone may use both the old
134      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
135      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      * @param _spender The address which will spend the funds.
138      * @param _value The amount of tokens to be spent.
139      */
140     function approve(address _spender, uint256 _value) returns (bool success) {
141         allowed[msg.sender][_spender] = _value;
142         Approval(msg.sender, _spender, _value);
143         return true;
144     }
145      
146     /**
147      * @dev Function to check the amount of tokens that an owner allowed to a spender.
148      * @param _owner address The address which owns the funds.
149      * @param _spender address The address which will spend the funds.
150      * @return A uint256 specifying the amount of tokens still available for the spender.
151      */
152     function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
153         return allowed[_owner][_spender];
154     }
155  
156  
157     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
158         totalSupply = totalSupply.add(_amount);
159         balances[_to] = balances[_to].add(_amount);
160         Mint(_to, _amount);
161         Transfer(address(0), _to, _amount);
162         return true;
163     }
164 
165     function finishMinting() onlyOwner canMint public returns (bool) {
166         mintingFinished = true;
167         MintFinished();
168         return true;
169     }
170     
171     event Transfer(address indexed _from, address indexed _to, uint256 _value);
172     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
173     event Mint(address indexed to, uint256 amount);
174     event MintFinished();
175     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
176 }