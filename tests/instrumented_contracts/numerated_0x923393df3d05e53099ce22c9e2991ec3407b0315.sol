1 pragma solidity ^0.4.17;
2 
3 
4 contract Ownable {
5     
6     address public owner;
7 
8     /**
9      * The address whcih deploys this contrcat is automatically assgined ownership.
10      * */
11     function Ownable() public {
12         owner = 0x53315fa129e1cCcC51d8575105755505750F5A38;
13     }
14 
15     /**
16      * Functions with this modifier can only be executed by the owner of the contract. 
17      * */
18     modifier onlyOwner {
19         require(msg.sender == owner);
20         _;
21     }
22 
23     event OwnershipTransferred(address indexed from, address indexed to);
24 
25     /**
26     * Transfers ownership to new Ethereum address. This function can only be called by the 
27     * owner.
28     * @param _newOwner the address to be granted ownership.
29     **/
30     function transferOwnership(address _newOwner) public onlyOwner {
31         require(_newOwner != 0x0);
32         OwnershipTransferred(owner, _newOwner);
33         owner = _newOwner;
34     }
35 }
36 
37 
38 library SafeMath {
39     
40     function mul(uint256 a, uint256 b) internal pure  returns (uint256) {
41         uint256 c = a * b;
42         assert(a == 0 || c / a == b);
43         return c;
44     }
45 
46     function div(uint256 a, uint256 b) internal pure  returns (uint256) {
47         uint256 c = a / b;
48         return c;
49     }
50 
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         assert(b <= a);
53         return a - b;
54     }
55 
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         assert(c >= a);
59         return c;
60     }
61 }
62 
63 
64 contract ERC20Basic {
65     uint256 public totalSupply;
66     string public name;
67     string public symbol;
68     uint8 public decimals;
69     function balanceOf(address who) constant public returns (uint256);
70     function transfer(address to, uint256 value) public returns (bool);
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 }
73 
74 
75 contract ERC20 {
76     function allowance(address owner, address spender) constant public returns (uint256);
77     function transferFrom(address from, address to, uint256 value) public  returns (bool);
78     function approve(address spender, uint256 value) public returns (bool);
79     event Approval(address indexed owner, address indexed spender, uint256 value);
80 }
81 
82 
83 contract BasicToken is ERC20Basic {
84     
85     using SafeMath for uint256;
86     
87     mapping (address => uint256) internal balances;
88     
89     /**
90     * Returns the balance of the qeuried address
91     *
92     * @param _who The address which is being qeuried
93     **/
94     function balanceOf(address _who) public view returns(uint256) {
95         return balances[_who];
96     }
97     
98     /**
99     * Allows for the transfer of MSTCOIN tokens from peer to peer. 
100     *
101     * @param _to The address of the receiver
102     * @param _value The amount of tokens to send
103     **/
104     function transfer(address _to, uint256 _value) public returns(bool) {
105         assert(balances[msg.sender] >= _value && _value > 0 && _to != 0x0);
106         balances[msg.sender] = balances[msg.sender].sub(_value);
107         balances[_to] = balances[_to].add(_value);
108         Transfer(msg.sender, _to, _value);
109         return true;
110     }
111 }
112 
113 
114 contract StandardToken is BasicToken, ERC20 {
115     
116     mapping (address => mapping (address => uint256)) internal allowances;
117     
118     /**
119     * Returns the amount of tokens one has allowed another to spend on his or her behalf.
120     *
121     * @param _owner The address which is the owner of the tokens
122     * @param _spender The address which has been allowed to spend tokens on the owner's
123     * behalf
124     **/
125     function allowance(address _owner, address _spender) public view returns (uint256) {
126         return allowances[_owner][_spender];
127     }
128     
129     /**
130     * Allows for the transfer of tokens on the behalf of the owner given that the owner has
131     * allowed it previously. 
132     *
133     * @param _from The address of the owner
134     * @param _to The address of the recipient 
135     * @param _value The amount of tokens to be sent
136     **/
137     function transferFrom(address _from, address _to, uint256 _value) public  returns (bool) {
138         assert(allowances[_from][msg.sender] >= _value && _to != 0x0 && balances[_from] >= _value);
139         balances[_from] = balances[_from].sub(_value);
140         balances[_to] = balances[_to].add(_value);
141         allowances[_from][msg.sender] = allowances[_from][msg.sender].sub(_value);
142         Transfer(_from, _to, _value);
143         return true;
144     }
145     
146     /**
147     * Allows the owner of tokens to approve another to spend tokens on his or her behalf
148     *
149     * @param _spender The address which is being allowed to spend tokens on the owner' behalf
150     * @param _value The amount of tokens to be sent
151     **/
152     function approve(address _spender, uint256 _value) public returns (bool) {
153         assert(_spender != 0x0 && _value >= 0);
154         allowances[msg.sender][_spender] = _value;
155         Approval(msg.sender, _spender, _value);
156         return true;
157     }
158 }
159 
160 
161 contract SaveCoin is StandardToken, Ownable {
162     
163     using SafeMath for uint256;
164     
165     mapping (address => uint256) balances;
166     mapping (address => mapping (address => uint256)) allowances;
167 
168      function SaveCoin() public{
169         totalSupply =  1000000000e18;
170         decimals =  18;
171         name =   "Save Coin";
172         symbol =  "SAVE";
173         balances[msg.sender] = totalSupply; 
174         Transfer (address(this), owner, totalSupply); 
175      }
176 
177 
178      function transfer(address _to, uint256 _value) public returns(bool) {
179         require(_value > 0 && balances[msg.sender] >= _value && _to != 0x0);
180         balances[_to] = balances[_to].add(_value);
181         balances[msg.sender] = balances[msg.sender].sub(_value);
182         Transfer(msg.sender, _to, _value);
183         return true;
184      }
185 
186 
187      function transferFrom(address _owner, address _recipient, uint256 _value) public returns(bool){
188          require(_value > 0 && balances[_owner] >= _value && allowances[_owner][msg.sender] >= _value && _recipient != 0x0);
189          allowances[_owner][msg.sender]= allowances [_owner][msg.sender].sub(_value);
190          balances[_owner] = balances [_owner].sub(_value);
191          balances[_recipient] = balances[_recipient].add(_value);
192          Transfer(_owner, _recipient, _value);   
193          return true;
194      }
195 
196 
197      function approve(address _spender, uint256 _value) public returns(bool) {
198          require(_spender != 0x0 && _value > 0x0);
199          allowances[msg.sender][_spender] = 0;
200          allowances[msg.sender][_spender] = _value;
201          Approval(msg.sender, _spender, _value);
202          return true;
203      }
204 
205 
206      function balanceOf(address _who) public constant returns(uint256) {
207         return balances[_who];
208      }
209 
210     function allowance(address _owner, address _spender) public constant returns(uint256) {
211         return allowances[_owner][_spender];
212      }
213 
214 }