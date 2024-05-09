1 pragma solidity ^0.4.23;
2 
3 contract Ownable
4 {
5     //--------------------------------------------------------------------------
6     //
7     //	Properties
8     //
9     //--------------------------------------------------------------------------
10 
11     address public owner;
12 
13 
14     //--------------------------------------------------------------------------
15     //
16     //	Events
17     //
18     //--------------------------------------------------------------------------
19 
20     event OwnershipRenounced(address indexed previousOwner);
21 
22     event OwnershipTransferred
23     (
24         address indexed previousOwner,
25         address indexed newOwner
26     );
27 
28 
29     //--------------------------------------------------------------------------
30     //
31     //	Constructor
32     //
33     //--------------------------------------------------------------------------
34 
35     constructor() public
36     {
37         owner = msg.sender;
38     }
39 
40     //--------------------------------------------------------------------------
41     //
42     //	Modifiers
43     //
44     //--------------------------------------------------------------------------
45 
46     modifier onlyOwner()
47     {
48         require(msg.sender == owner);
49         _;
50     }
51 
52     //--------------------------------------------------------------------------
53     //
54     //	Public Methods
55     //
56     //--------------------------------------------------------------------------
57 
58     function renounceOwnership() public onlyOwner
59     {
60         emit OwnershipRenounced(owner);
61         owner = address(0);
62     }
63 
64     function transferOwnership(address _newOwner) public onlyOwner
65     {
66         _transferOwnership(_newOwner);
67     }
68 
69     function _transferOwnership(address _newOwner) internal
70     {
71         require(_newOwner != address(0));
72         emit OwnershipTransferred(owner, _newOwner);
73         owner = _newOwner;
74     }
75 }
76 
77 library SafeMath
78 {
79     function mul(uint256 a, uint256 b) internal pure returns (uint256 c)
80     {
81         if(a == 0)
82         {
83             return 0;
84         }
85 
86         c = a * b;
87         assert(c / a == b);
88         return c;
89     }
90 
91     function div(uint256 a, uint256 b) internal pure returns (uint256)
92     {
93         return a / b;
94     }
95 
96     function sub(uint256 a, uint256 b) internal pure returns (uint256)
97     {
98         assert(b <= a);
99         return a - b;
100     }
101 
102     function add(uint256 a, uint256 b) internal pure returns (uint256 c)
103     {
104         c = a + b;
105         assert(c >= a);
106         return c;
107     }
108 }
109 
110 contract ERC20Basic
111 {
112     //--------------------------------------------------------------------------
113     //
114     //	Public Methods
115     //
116     //--------------------------------------------------------------------------
117 
118     function totalSupply() public view returns (uint256);
119     function balanceOf(address who) public view returns (uint256);
120     function transfer(address to, uint256 value) public returns (bool);
121 
122     //--------------------------------------------------------------------------
123     //
124     //	Events
125     //
126     //--------------------------------------------------------------------------
127 
128     event Transfer(address indexed from, address indexed to, uint256 value);
129 }
130 
131 
132 contract ERC20 is ERC20Basic
133 {
134     //--------------------------------------------------------------------------
135     //
136     //	Public Methods
137     //
138     //--------------------------------------------------------------------------
139 
140     function allowance(address owner, address spender) public view returns (uint256);
141 
142     function transferFrom(address from, address to, uint256 value) public returns (bool);
143 
144     function approve(address spender, uint256 value) public returns (bool);
145 
146     //--------------------------------------------------------------------------
147     //
148     //	Events
149     //
150     //--------------------------------------------------------------------------
151 
152     event Approval
153     (
154         address indexed owner,
155         address indexed spender,
156         uint256 value
157     );
158 }
159 
160 contract TokenDestructible is Ownable
161 {
162     //--------------------------------------------------------------------------
163     //
164     //	Constructor
165     //
166     //--------------------------------------------------------------------------
167 
168     constructor() public payable { }
169 
170     //--------------------------------------------------------------------------
171     //
172     //	Public Methods
173     //
174     //--------------------------------------------------------------------------
175 
176     function destroy(address[] tokens) onlyOwner public
177     {
178         for (uint256 i = 0; i < tokens.length; i++)
179         {
180             ERC20Basic token = ERC20Basic(tokens[i]);
181             uint256 balance = token.balanceOf(this);
182             token.transfer(owner, balance);
183         }
184 
185         selfdestruct(owner);
186     }
187 }
188 
189 contract BasicToken is ERC20Basic
190 {
191     using SafeMath for uint256;
192 
193     //--------------------------------------------------------------------------
194     //
195     //	Properties
196     //
197     //--------------------------------------------------------------------------
198 
199     mapping(address => uint256) balances;
200 
201     uint256 totalSupply_;
202 
203     //--------------------------------------------------------------------------
204     //
205     //	Public Methods
206     //
207     //--------------------------------------------------------------------------
208 
209     function totalSupply() public view returns (uint256)
210     {
211         return totalSupply_;
212     }
213 
214     function transfer(address _to, uint256 _value) public returns (bool)
215     {
216         require(_to != address(0));
217         require(_value <= balances[msg.sender]);
218 
219         balances[msg.sender] = balances[msg.sender].sub(_value);
220         balances[_to] = balances[_to].add(_value);
221         emit Transfer(msg.sender, _to, _value);
222         return true;
223     }
224 
225     function balanceOf(address _owner) public view returns (uint256)
226     {
227         return balances[_owner];
228     }
229 }
230 
231 contract StandardToken is ERC20, BasicToken
232 {
233     //--------------------------------------------------------------------------
234     //
235     //	Properties
236     //
237     //--------------------------------------------------------------------------
238 
239     mapping (address => mapping (address => uint256)) internal allowed;
240 
241     //--------------------------------------------------------------------------
242     //
243     //	Public Methods
244     //
245     //--------------------------------------------------------------------------
246 
247     function transferFrom(address _from,address _to,uint256 _value) public returns (bool)
248     {
249         require(_to != address(0));
250         require(_value <= balances[_from]);
251         require(_value <= allowed[_from][msg.sender]);
252 
253         balances[_from] = balances[_from].sub(_value);
254         balances[_to] = balances[_to].add(_value);
255         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
256         emit Transfer(_from, _to, _value);
257         return true;
258     }
259 
260     function approve(address _spender,uint256 _value) public returns (bool)
261     {
262         allowed[msg.sender][_spender] = _value;
263         emit Approval(msg.sender, _spender, _value);
264         return true;
265     }
266 
267     function allowance(address _owner,address _spender) public view returns (uint256)
268     {
269         return allowed[_owner][_spender];
270     }
271 
272     function increaseApproval(address _spender,uint _addedValue) public returns (bool)
273     {
274         allowed[msg.sender][_spender] = (allowed[msg.sender][_spender].add(_addedValue));
275         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276         return true;
277     }
278 
279     function decreaseApproval(address _spender,uint _subtractedValue) public returns (bool)
280     {
281         uint oldValue = allowed[msg.sender][_spender];
282         if(_subtractedValue > oldValue)
283         {
284             allowed[msg.sender][_spender] = 0;
285         }
286         else
287         {
288             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
289         }
290         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
291         return true;
292     }
293 }
294 
295 contract BurnableToken is BasicToken
296 {
297 
298     //--------------------------------------------------------------------------
299     //
300     //	Events
301     //
302     //--------------------------------------------------------------------------
303 
304     event Burn(address indexed burner, uint256 value);
305 
306     //--------------------------------------------------------------------------
307     //
308     //	Public Methods
309     //
310     //--------------------------------------------------------------------------
311 
312     function burn(uint256 _value) public
313     {
314         _burn(msg.sender, _value);
315     }
316 
317     function _burn(address _who, uint256 _value) internal
318     {
319         require(_value <= balances[_who]);
320         balances[_who] = balances[_who].sub(_value);
321         totalSupply_ = totalSupply_.sub(_value);
322         emit Burn(_who, _value);
323         emit Transfer(_who, address(0), _value);
324     }
325 }
326 
327 contract StandardBurnableToken is BurnableToken, StandardToken
328 {
329     //--------------------------------------------------------------------------
330     //
331     //	Public Methods
332     //
333     //--------------------------------------------------------------------------
334 
335     function burnFrom(address _from, uint256 _value) public
336     {
337         require(_value <= allowed[_from][msg.sender]);
338         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
339         _burn(_from, _value);
340     }
341 
342 }
343 
344 contract TrinoToken is StandardBurnableToken,TokenDestructible
345 {
346     //--------------------------------------------------------------------------
347     //
348     //	Properties
349     //
350     //--------------------------------------------------------------------------
351 
352     string public name = "TRINO";
353     string public symbol = "TIO";
354 
355     uint public decimals = 18;
356     uint256 public INITIAL_SUPPLY = 3750000000 * (10 ** decimals); // 3 750 000 000
357 
358     //--------------------------------------------------------------------------
359     //
360     //	Constructor
361     //
362     //--------------------------------------------------------------------------
363 
364     constructor() public
365     {
366         owner = msg.sender;
367         totalSupply_ = INITIAL_SUPPLY;
368         balances[owner] = INITIAL_SUPPLY;
369     }
370 
371 }