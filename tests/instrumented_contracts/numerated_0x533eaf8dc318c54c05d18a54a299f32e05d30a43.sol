1 pragma solidity ^0.4.25;
2 
3 /*** @title SafeMath*/
4 library SafeMath {
5 	function mul(uint a, uint b) internal returns (uint) {
6 		uint c = a * b;
7 		assert(a == 0 || c / a == b);
8 		return c;
9 	}
10 	function div(uint a, uint b) internal returns (uint) {
11 		// assert(b > 0); // Solidity automatically throws when dividing by 0
12 		uint c = a / b;
13 		// assert(a == b * c + a % b); // There is no case in which this doesn't hold
14 		return c;
15 	}
16 	function sub(uint a, uint b) internal returns (uint) {
17 		assert(b <= a);
18 		return a - b;
19 	}
20 	function add(uint a, uint b) internal returns (uint) {
21 		uint c = a + b;
22 		assert(c >= a);
23 		return c;
24 	}
25 	function max64(uint64 a, uint64 b) internal constant returns (uint64) {
26 		return a >= b ? a : b;
27 	}
28 	function min64(uint64 a, uint64 b) internal constant returns (uint64) {
29 		return a < b ? a : b;
30 	}
31 	function max256(uint256 a, uint256 b) internal constant returns (uint256) {
32 		return a >= b ? a : b;
33 	}
34 	function min256(uint256 a, uint256 b) internal constant returns (uint256) {
35 		return a < b ? a : b;
36 	}
37 	function assert(bool assertion) internal {
38 		if (!assertion) {
39 			throw;
40 		}
41 	}
42 }
43 
44 
45 /*** @title ERC20 interface */
46 contract ERC20 {
47   function totalSupply() public view returns (uint256);  
48   function balanceOf(address _owner) public view returns (uint256);  
49   function transfer(address _to, uint256 _value) public returns (bool);  
50   function transferFrom(address _from, address _to, uint256 _value) public returns (bool);  
51   function approve(address _spender, uint256 _value) public returns (bool);  
52   function allowance(address _owner, address _spender) public view returns (uint256);  
53   event Transfer(address indexed _from, address indexed _to, uint256 _value);  
54   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
55 }
56 
57 
58 /*** @title ERC223 interface */
59 contract ERC223ReceivingContract {
60     function tokenFallback(address _from, uint _value, bytes _data) public;
61 }
62 contract ERC223 {
63     function balanceOf(address who) public constant returns (uint);
64     function transfer(address to, uint value) public returns(bool);
65     function transfer(address to, uint value, bytes data) public returns(bool);
66     event Transfer(address indexed from, address indexed to, uint value); //ERC 20 style
67     //event Transfer(address indexed from, address indexed to, uint value, bytes data);
68 }
69 /*** @title ERC223 token */
70 contract ERC223Token is ERC223{
71 	using SafeMath for uint;
72 
73 	mapping(address => uint256) balances;
74   
75 	function transfer(address _to, uint _value) public returns(bool){
76 		uint codeLength;
77 		bytes memory empty;
78 		assembly {
79 			// Retrieve the size of the code on target address, this needs assembly .
80 			codeLength := extcodesize(_to)
81 		}
82 
83 		require(_value > 0);
84 		require(balances[msg.sender] >= _value);
85 		require(balances[_to]+_value > 0);
86 		balances[msg.sender] = balances[msg.sender].sub(_value);
87 		balances[_to] = balances[_to].add(_value);
88 		if(codeLength>0) {
89 			ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
90 			receiver.tokenFallback(msg.sender, _value, empty);
91 			return false;
92 		}
93 		emit Transfer(msg.sender, _to, _value);
94 		return true;
95 	}
96   
97 	function transfer(address _to, uint _value, bytes _data) public returns(bool){
98 		// Standard function transfer similar to ERC20 transfer with no _data .
99 		// Added due to backwards compatibility reasons .
100 		uint codeLength;
101 		assembly {
102 			// Retrieve the size of the code on target address, this needs assembly .
103 			codeLength := extcodesize(_to)
104 		}
105 
106 		require(_value > 0);
107 		require(balances[msg.sender] >= _value);
108 		require(balances[_to]+_value > 0);
109 		
110 		balances[msg.sender] = balances[msg.sender].sub(_value);
111 		balances[_to] = balances[_to].add(_value);
112 		if(codeLength>0) {
113 			ERC223ReceivingContract receiver = ERC223ReceivingContract(_to);
114 			receiver.tokenFallback(msg.sender, _value, _data);
115 			return false;
116 		}
117 		emit Transfer(msg.sender, _to, _value);
118 		return true;
119 	} 
120 
121 	function balanceOf(address _owner) public view returns (uint256) {    
122 		return balances[_owner];
123 	}
124   
125 }
126 
127 //////////////////////////////////////////////////////////////////////////
128 //////////////////////// [Ding token] MAIN ////////////////////////
129 //////////////////////////////////////////////////////////////////////////
130 /*** @title Owned */
131 contract Owned {
132 	address public owner;
133 	constructor() public {
134 		owner = msg.sender;
135 		//owner = 0x43Fb2e04aC5B382Fc6ff29Ac34D3Ca221cEE402E;
136 	}
137 	modifier onlyOwner {
138 		require(msg.sender == owner);
139 		_;
140 	}
141 }
142 /*** @title Ding Token */
143 contract DING is ERC223Token, Owned{
144     
145     string public constant name = "Ding Ding Token";
146     string public constant symbol = "DING";
147     uint8  public constant decimals = 18;
148 
149     uint256 public tokenRemained = 2 * (10 ** 9) * (10 ** 18); // 2 billion DING, decimals set to 18
150     uint256 public totalSupply   = 2 * (10 ** 9) * (10 ** 18);
151     
152 
153     bool public pause=false;
154 
155     mapping(address => bool) lockAddresses;
156     
157     // constructor
158     function DING(){    
159         //allocate to ______
160         balances[0xd8686d2aB1a65149FDd4ee36c60d161c274C41e0]= totalSupply;
161     	emit Transfer(0x0,0xd8686d2aB1a65149FDd4ee36c60d161c274C41e0,totalSupply);
162     }
163 
164     // change the contract owner
165     event ChangeOwner(address indexed _from,address indexed _to);
166     function changeOwner(address _new) public onlyOwner{
167         emit ChangeOwner(owner,_new);
168         owner=_new;
169     }
170 
171 
172     
173 
174     // pause all the transfer on the contract 
175     event PauseContract();
176     function pauseContract() public onlyOwner{
177         pause = true;
178         emit PauseContract();
179     }
180     event ResumeContract();
181     function resumeContract() public onlyOwner{
182         pause = false;
183         emit ResumeContract();
184     }
185     function is_contract_paused() public view returns(bool){
186         return pause;
187     }
188     
189 
190     // lock one's wallet
191     event Lock(address _addr);
192     function lock(address _addr) public onlyOwner{
193         lockAddresses[_addr] = true; 
194         emit Lock(_addr);
195     }
196     event Unlock(address _addr);
197     function unlock(address _addr) public onlyOwner{
198         lockAddresses[_addr] = false;
199         emit Unlock(_addr); 
200     }
201     function am_I_locked(address _addr) public view returns(bool){
202     	return lockAddresses[_addr];
203     }
204     
205   
206     // eth
207     
208   	
209     function() payable {
210     
211     }
212     
213     function getETH(uint256 _amount) public onlyOwner{
214         msg.sender.transfer(_amount);
215     }
216      
217 
218     /////////////////////////////////////////////////////////////////////
219     ///////////////// ERC223 Standard functions /////////////////////////
220     /////////////////////////////////////////////////////////////////////
221     modifier transferable(address _addr) {
222         require(!pause);
223     	require(!lockAddresses[_addr]);
224     	_;
225     }
226     function transfer(address _to, uint _value, bytes _data) public transferable(msg.sender) returns (bool) {
227     	return super.transfer(_to, _value, _data);
228     }
229     function transfer(address _to, uint _value) public transferable(msg.sender) returns (bool) {
230 		return super.transfer(_to, _value);
231     }
232 
233 
234     /////////////////////////////////////////////////////////////////////
235     ///////////////////  Rescue functions  //////////////////////////////
236     /////////////////////////////////////////////////////////////////////
237     function transferAnyERC20Token(address _tokenAddress, uint256 _value) public onlyOwner returns (bool) {
238     	return ERC20(_tokenAddress).transfer(owner, _value);
239   	}
240 }