1 pragma solidity ^ 0.4.19;
2 
3 
4 contract Ownable {
5     address public owner;
6     function Ownable() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14     
15     
16    
17 }
18 
19 
20 contract CREDITS is Ownable{
21     /* Public variables of the token */
22     string public name = 'CREDITS';
23     string public symbol = 'CS';
24     uint8 public decimals = 6;
25     uint256 public totalSupply = 1000000000000000;
26     uint public TotalHoldersAmount;
27     /*Freeze transfer from all accounts */
28     bool public Frozen=true;
29     bool public CanChange=true;
30     address public Admin;
31     address public AddressForReturn;
32     address[] Accounts;
33     /* This creates an array with all balances */
34     mapping(address => uint256) public balanceOf;
35     mapping(address => mapping(address => uint256)) public allowance;
36    /*Individual Freeze*/
37     mapping(address => bool) public AccountIsFrozen;
38     /*Allow transfer for ICO, Admin accounts if IsFrozen==true*/
39     mapping(address => bool) public AccountIsNotFrozen;
40    /*Allow transfer tokens only to ReturnWallet*/
41     mapping(address => bool) public AccountIsNotFrozenForReturn;
42     mapping(address => uint) public AccountIsFrozenByDate;
43     
44     mapping (address => bool) public isHolder;
45     mapping (address => bool) public isArrAccountIsFrozen;
46     mapping (address => bool) public isArrAccountIsNotFrozen;
47     mapping (address => bool) public isArrAccountIsNotFrozenForReturn;
48     mapping (address => bool) public isArrAccountIsFrozenByDate;
49     address [] public Arrholders;
50     address [] public ArrAccountIsFrozen;
51     address [] public ArrAccountIsNotFrozen;
52     address [] public ArrAccountIsNotFrozenForReturn;
53     address [] public ArrAccountIsFrozenByDate;
54    
55     
56     
57     /* This generates a public event on the blockchain that will notify clients */
58     event Transfer(address indexed from, address indexed to, uint256 value);
59     event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
60     event Burn(address indexed from, uint256 value);
61     
62     modifier IsNotFrozen{
63       require(((!Frozen&&AccountIsFrozen[msg.sender]!=true)||((Frozen)&&AccountIsNotFrozen[msg.sender]==true))&&now>AccountIsFrozenByDate[msg.sender]);
64       _;
65      }
66      
67      modifier isCanChange{
68       require((msg.sender==owner||msg.sender==Admin)&&CanChange==true);
69       _;
70      }
71      
72      
73      
74      
75     /* Initializes contract with initial supply tokens to the creator of the contract */
76    
77   function CREDITS() public {
78         balanceOf[msg.sender] = totalSupply;
79         Arrholders[Arrholders.length++]=msg.sender;
80         Admin=msg.sender;
81     }
82     
83      function setAdmin(address _address) public onlyOwner{
84         require(CanChange);
85         Admin=_address;
86     }
87     
88    function setFrozen(bool _Frozen)public onlyOwner{
89       require(CanChange);
90       Frozen=_Frozen;
91     }
92     
93     function setCanChange(bool _canChange)public onlyOwner{
94       require(CanChange);
95       CanChange=_canChange;
96     }
97     
98     function setAccountIsFrozen(address _address, bool _IsFrozen)public isCanChange{
99      AccountIsFrozen[_address]=_IsFrozen;
100      if (isArrAccountIsFrozen[_address] != true) {
101         ArrAccountIsFrozen[ArrAccountIsFrozen.length++] = _address;
102         isArrAccountIsFrozen[_address] = true;
103     }
104     }
105     
106     function setAccountIsNotFrozen(address _address, bool _IsFrozen)public isCanChange{
107      AccountIsNotFrozen[_address]=_IsFrozen;
108      if (isArrAccountIsNotFrozen[_address] != true) {
109         ArrAccountIsNotFrozen[ArrAccountIsNotFrozen.length++] = _address;
110         isArrAccountIsNotFrozen[_address] = true;
111     }
112     }
113     
114     function setAccountIsNotFrozenForReturn(address _address, bool _IsFrozen)public isCanChange{
115      AccountIsNotFrozenForReturn[_address]=_IsFrozen;
116       if (isArrAccountIsNotFrozenForReturn[_address] != true) {
117         ArrAccountIsNotFrozenForReturn[ArrAccountIsNotFrozenForReturn.length++] = _address;
118         isArrAccountIsNotFrozenForReturn[_address] = true;
119     }
120     }
121     
122     function setAccountIsFrozenByDate(address _address, uint _Date)public isCanChange{
123     
124         require (!isArrAccountIsFrozenByDate[_address]);
125         AccountIsFrozenByDate[_address]=_Date;
126         ArrAccountIsFrozenByDate[ArrAccountIsFrozenByDate.length++] = _address;
127         isArrAccountIsFrozenByDate[_address] = true;
128     
129     }
130     
131     /* Send coins */
132     function transfer(address _to, uint256 _value) public  {
133         require(((!Frozen&&AccountIsFrozen[msg.sender]!=true)||((Frozen)&&AccountIsNotFrozen[msg.sender]==true)||(AccountIsNotFrozenForReturn[msg.sender]==true&&_to==AddressForReturn))&&now>AccountIsFrozenByDate[msg.sender]);
134         require(balanceOf[msg.sender] >= _value); // Check if the sender has enough
135         require (balanceOf[_to] + _value >= balanceOf[_to]); // Check for overflows
136         balanceOf[msg.sender] -= _value; // Subtract from the sender
137         balanceOf[_to] += _value; // Add the same to the recipient
138         Transfer(msg.sender, _to, _value); // Notify anyone listening that this transfer took place
139         if (isHolder[_to] != true) {
140         Arrholders[Arrholders.length++] = _to;
141         isHolder[_to] = true;
142     }}
143     
144   
145  
146     /* Allow another contract to spend some tokens in your behalf */
147     function approve(address _spender, uint256 _value)public
148     returns(bool success) {
149         allowance[msg.sender][_spender] = _value;
150         Approval(msg.sender, _spender, _value);
151         return true;
152     }
153 
154    
155 
156     /* A contract attempts to get the coins */
157     function transferFrom(address _from, address _to, uint256 _value)public IsNotFrozen returns(bool success)  {
158         require(((!Frozen&&AccountIsFrozen[_from]!=true)||((Frozen)&&AccountIsNotFrozen[_from]==true))&&now>AccountIsFrozenByDate[_from]);
159         require (balanceOf[_from] >= _value) ; // Check if the sender has enough
160         require (balanceOf[_to] + _value >= balanceOf[_to]) ; // Check for overflows
161         require (_value <= allowance[_from][msg.sender]) ; // Check allowance
162         balanceOf[_from] -= _value; // Subtract from the sender
163         balanceOf[_to] += _value; // Add the same to the recipient
164         allowance[_from][msg.sender] -= _value;
165         Transfer(_from, _to, _value);
166         if (isHolder[_to] != true) {
167         Arrholders[Arrholders.length++] = _to;
168         isHolder[_to] = true;
169         }
170         return true;
171     }
172  /* @param _value the amount of money to burn*/
173    
174     function burn(uint256 _value) public IsNotFrozen  returns (bool success) {
175         require(balanceOf[msg.sender] >= _value);   // Check if the sender has enough
176         balanceOf[msg.sender] -= _value;            // Subtract from the sender
177         totalSupply -= _value;                      // Updates totalSupply
178         Burn(msg.sender, _value);
179         return true;
180     }
181      /* Destroy tokens from other account  */
182    
183     function burnFrom(address _from, uint256 _value) public IsNotFrozen returns (bool success) {
184         require(((!Frozen&&AccountIsFrozen[_from]!=true)||((Frozen)&&AccountIsNotFrozen[_from]==true))&&now>AccountIsFrozenByDate[_from]);
185         require(balanceOf[_from] >= _value);                // Check if the targeted balance is enough
186         require(_value <= allowance[_from][msg.sender]);    // Check allowance
187         balanceOf[_from] -= _value;                         // Subtract from the targeted balance
188         allowance[_from][msg.sender] -= _value;             // Subtract from the sender's allowance
189         totalSupply -= _value;                              // Update totalSupply
190         Burn(_from, _value);
191         return true;
192     }
193         
194    
195     
196     function GetHoldersCount () public view returns (uint _HoldersCount){
197   
198          return (Arrholders.length-1);
199     }
200     
201     function GetAccountIsFrozenCount () public view returns (uint _Count){
202   
203          return (ArrAccountIsFrozen.length);
204     }
205     
206     function GetAccountIsNotFrozenForReturnCount () public view returns (uint _Count){
207   
208          return (ArrAccountIsNotFrozenForReturn.length);
209     }
210     
211     function GetAccountIsNotFrozenCount () public view returns (uint _Count){
212   
213          return (ArrAccountIsNotFrozen.length);
214     }
215     
216      function GetAccountIsFrozenByDateCount () public view returns (uint _Count){
217   
218          return (ArrAccountIsFrozenByDate.length);
219     }
220      
221      function SetAddressForReturn (address _address) public isCanChange  returns (bool success ){
222          AddressForReturn=_address;
223          return true;
224     }
225     
226     function setSymbol(string _symbol) public onlyOwner {
227         require(CanChange);
228         symbol = _symbol;
229     }
230     
231     function setName(string _name) public onlyOwner {
232         require(CanChange);
233         name = _name;
234     }
235     
236     
237     /* This unnamed function is called whenever someone tries to send ether to it */
238    function () public payable {
239          revert();
240     }
241 }