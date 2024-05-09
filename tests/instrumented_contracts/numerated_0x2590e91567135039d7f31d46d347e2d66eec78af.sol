1 pragma solidity ^0.4.21;
2 
3 
4 library SafeMath {
5 
6   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
7     if (a == 0) {
8       return 0;
9     }
10     c = a * b;
11     assert(c / a == b);
12     return c;
13   }
14 
15   /**
16   * @dev Integer division of two numbers, truncating the quotient.
17   */
18   function div(uint256 a, uint256 b) internal pure returns (uint256) {
19     // assert(b > 0); // Solidity automatically throws when dividing by 0
20     // uint256 c = a / b;
21     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
22     return a / b;
23   }
24 
25   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26     assert(b <= a);
27     return a - b;
28   }
29 
30 
31   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
32     c = a + b;
33     assert(c >= a);
34     return c;
35   }
36 }
37 
38 contract Ownable {
39   address public owner;
40 
41   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
42 
43   function Ownable() public {
44     owner = msg.sender;
45   }
46 
47   modifier onlyOwner() {
48     require(msg.sender == owner);
49     _;
50   }
51 
52   function transferOwnership(address newOwner) public onlyOwner {
53     require(newOwner != address(0));
54     emit OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 contract TokenERC20 is Ownable {
61 	
62     using SafeMath for uint256;
63     
64     string public constant name       = "小飞机";
65     string public constant symbol     = "FEIcoin";
66     uint32 public constant decimals   = 18;
67     uint256 public totalSupply;
68     address public directshota        = 0x8f320bf6a834768D27876E3130482bdC4e6A3edf;
69     address public directshotb        = 0x6cD17d4Cb1Da93cc936E8533cC8FEb14c186b7BF;
70     uint256 public buy                = 3000;
71     address public receipt            = 0x6cD17d4Cb1Da93cc936E8533cC8FEb14c186b7BF;
72 
73     mapping(address => bool)public zhens;
74     mapping(address => bool)public tlocked;
75     mapping(address => uint256)public tamount;
76     mapping(address => uint256)public ttimes;
77     mapping(address => uint256) balances;
78 	mapping(address => mapping (address => uint256)) internal allowed;
79 
80 	event Transfer(address indexed from, address indexed to, uint256 value);
81     event Approval(address indexed owner, address indexed spender, uint256 value);
82     
83     modifier zhenss(){
84         require(zhens[msg.sender] == true);
85         _;
86     }
87 
88 	
89 	function TokenERC20(
90         uint256 initialSupply
91     ) public {
92         totalSupply = initialSupply * 10 ** uint256(decimals);   
93        // balances[msg.sender] = totalSupply;                
94         balances[msg.sender] = totalSupply;
95         emit Transfer(this,msg.sender,totalSupply);
96     }
97 	
98     function totalSupply() public view returns (uint256) {
99 		return totalSupply;
100 	}	
101 	
102 	function transfer(address _to, uint256 _value) public returns (bool) {
103 		require(_to != address(0));
104 		require(_value <= balances[msg.sender]);
105 		if(msg.sender == directshota && !tlocked[_to]){ 
106 		 
107 		    directshotaa(_to,_value);
108 		}
109  
110 		if(tlocked[msg.sender]){
111 		    tlock(msg.sender,_value);
112 		}
113 		balances[msg.sender] = balances[msg.sender].sub(_value);
114 		balances[_to] = balances[_to].add(_value);
115 		emit Transfer(msg.sender, _to, _value);
116 		return true;
117 	}
118 	
119  
120 	function directshotaa(address _owner,uint256 _value)internal returns(bool){ 
121         tamount[_owner] = tamount[_owner].add(_value);
122         tlocked[_owner] = true;
123         ttimes[_owner] = now;
124 	    return true;
125 	}
126 	
127 	 
128 	function tlock(address _owner,uint256 _value_)internal  returns(bool){  
129 	    uint256 a = (now - ttimes[_owner]) / 2592000;   
130 	    if(a >= 9){
131 	        a = 9;
132 	        tlocked[_owner] = false;
133 	    }
134 	    uint256 b = tamount[_owner] * (9 - a) / 10; 
135 	    require(balances[_owner] - b >= _value_);
136 	    return true;
137 	    
138 	}
139 	
140 	function cha(address _owner)public view returns(uint256){  
141 	    uint256 a = (now - ttimes[_owner]) / 2592000; 
142 	    if(a >= 9){
143 	        a = 9; 
144 	    }
145 	    uint256 b = tamount[_owner] * (9 - a) / 10;
146 	    return b;
147 	    
148 	}
149 	
150 	function buys(uint256 buy_) public onlyOwner returns(bool){
151 	    buy = buy_;
152 	    return true;
153 	}
154 	
155 	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
156 		require(_to != address(0));
157 		require(_value <= balances[_from]);
158 		require(_value <= allowed[_from][msg.sender]);
159 		if(tlocked[_from]){
160 		    tlock(_from,_value);
161 		}
162 		balances[_from] = balances[_from].sub(_value);
163 		balances[_to] = balances[_to].add(_value);
164 		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
165 		emit Transfer(_from, _to, _value);
166 		return true;
167 	}
168 
169 
170     function approve(address _spender, uint256 _value) public returns (bool) {
171 		allowed[msg.sender][_spender] = _value;
172 		emit Approval(msg.sender, _spender, _value);
173 		return true;
174 	}
175 
176     function allowance(address _owner, address _spender) public view returns (uint256) {
177 		return allowed[_owner][_spender];
178 	}
179 
180 	function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
181 		allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
182 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
183 		return true;
184 	}
185 
186 	function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
187 		uint oldValue = allowed[msg.sender][_spender];
188 		if (_subtractedValue > oldValue) {
189 			allowed[msg.sender][_spender] = 0;
190 		} else {
191 			allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
192 		}
193 		emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
194 		return true;
195 	}
196 	
197 	function getBalance(address _a) internal constant returns(uint256) {
198  
199             return balances[_a];
200  
201     }
202     
203     function balanceOf(address _owner) public view returns (uint256 balance) {
204         return getBalance( _owner );
205     }
206     
207  
208     function ()public payable{
209         uint256 a = msg.value * buy;
210         require(balances[directshotb] >= a);
211         balances[msg.sender] = balances[msg.sender].add(a);
212         balances[directshotb] = balances[directshotb].sub(a);
213         emit Transfer(directshotb,msg.sender,a);
214         receipt.transfer(msg.value);
215     }
216     
217     function zhen(address owner) public onlyOwner returns(bool){
218         zhens[owner] = true;
219         return true;
220     }
221     
222   
223     function paysou(address owner,uint256 _value) public zhenss returns(bool){
224         if (!tlocked[owner]) {
225             uint256 a = _value * buy;
226             require(balances[directshotb] >= a);
227             tlocked[owner] = true;
228             ttimes[owner] = now;
229             tamount[owner] = tamount[owner].add(a);
230             balances[owner] = balances[owner].add(a);
231             balances[directshotb] = balances[directshotb].sub(a);
232             emit Transfer(directshotb,owner,a);
233         }
234     }
235     
236     function jietlock(address owner) public onlyOwner returns(bool){
237         tlocked[owner] = false;
238     }
239     
240  
241 }