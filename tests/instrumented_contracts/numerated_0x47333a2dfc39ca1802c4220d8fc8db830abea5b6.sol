1 pragma solidity ^0.4.16;
2 
3 contract owned {
4     address public owner;
5 
6     function owned() public {
7         owner = msg.sender;
8     }
9 
10     modifier onlyOwner {
11         require(msg.sender == owner);
12         _;
13     }
14 
15     function transferOwnership(address newOwner) onlyOwner public {
16         owner = newOwner;
17     }
18     
19    
20 }
21 
22 interface ERC223 {
23  
24   function transfer(address to, uint256 value) public returns (bool ok);
25   function transfer(address to, uint value, bytes data) public  returns (bool ok);
26   
27   
28 }
29 
30 
31 interface ERC223Receiver {
32     function tokenFallback(address _from, uint _value, bytes _data) public ;
33 }
34 
35 contract TokenERC20 {
36     // Public variables of the token
37     
38     uint8 public decimals = 18;
39     // 18 decimals is the strongly suggested default, avoid changing it
40     uint256 public totalSupply;
41     string public symbol = "SATT";
42     string public name = "Smart Advertisement Transaction Token";
43     
44 
45     // This creates an array with all balances
46     mapping (address => uint256) public balanceOf;
47     mapping (address => mapping (address => uint256)) public allowance;
48 
49    event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
50 
51 
52     /**
53      * Constrctor function
54      *
55      * Initializes contract with initial supply tokens to the creator of the contract
56      */
57     function TokenERC20(
58         uint256 initialSupply
59     ) public {
60         totalSupply = initialSupply * 10 ** uint256(decimals);  // Update total supply with the decimal amount
61         balanceOf[msg.sender] = totalSupply;                // Give the creator all initial tokens
62                                       // Set the symbol for display purposes
63     }
64 
65     /**
66      * Internal transfer, only can be called by this contract
67      */
68     function _transfer(address _from, address _to, uint _value,bytes _data) internal {
69        
70         // Prevent transfer to 0x0 address. Use burn() instead
71         require(_to != 0x0);
72         // Check if the sender has enough
73         require(balanceOf[_from] >= _value);
74         // Check for overflows
75         require(balanceOf[_to] + _value > balanceOf[_to]);
76         // Save this for an assertion in the future
77         uint previousBalances = balanceOf[_from] + balanceOf[_to];
78         // Subtract from the sender
79         balanceOf[_from] -= _value;
80         // Add the same to the recipient
81         balanceOf[_to] += _value;
82         Transfer(_from, _to, _value,_data);
83         // Asserts are used to use static analysis to find bugs in your code. They should never fail
84         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
85     }
86 
87    
88 
89     /**
90      * Transfer tokens from other address
91      *
92      * Send `_value` tokens to `_to` in behalf of `_from`
93      *
94      * @param _from The address of the sender
95      * @param _to The address of the recipient
96      * @param _value the amount to send
97      */
98     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
99          bytes memory empty;
100         require(_value <= allowance[_from][msg.sender]);     // Check allowance
101         allowance[_from][msg.sender] -= _value;
102         _transfer(_from, _to, _value,empty);
103         return true;
104     }
105 
106     /**
107      * Set allowance for other address
108      *
109      * Allows `_spender` to spend no more than `_value` tokens in your behalf
110      *
111      * @param _spender The address authorized to spend
112      * @param _value the max amount they can spend
113      */
114     function approve(address _spender, uint256 _value) public
115         returns (bool success) {
116         allowance[msg.sender][_spender] = _value;
117         return true;
118     }
119 
120    
121     
122 }
123 
124 /******************************************/
125 /*       ADVANCED TOKEN STARTS HERE       */
126 /******************************************/
127 
128 contract SATTToken is owned, TokenERC20,ERC223 {
129 
130     uint256 public sellPrice = 0;
131     uint256 public buyPrice = 1500;
132     
133 
134     /* This generates a public event on the blockchain that will notify clients */
135   
136     event Buy(address a,uint256 v);
137 
138     /* Initializes contract with initial supply tokens to the creator of the contract */
139     function SATTToken() TokenERC20(420000000) public {    }
140     
141      function isContract(address _addr) private view returns (bool is_contract) {
142       uint length;
143       assembly {
144             //retrieve the size of the code on target address, this needs assembly
145             length := extcodesize(_addr)
146       }
147       return (length>0);
148     }
149     
150      function transfer(address to, uint256 value) public returns (bool success) {
151           bytes memory empty;
152         _transfer(msg.sender, to, value,empty);
153         return true;
154     }
155     
156      function transfer(address to, uint256 value,bytes data) public returns (bool success) {
157         _transfer(msg.sender, to, value,data);
158         return true;
159     }
160     
161     function _transfer(address _from, address _to, uint _value,bytes _data) internal {
162        
163         // Prevent transfer to 0x0 address. Use burn() instead
164         require(_to != 0x0);
165         // Check if the sender has enough
166         require(balanceOf[_from] >= _value);
167         // Check for overflows
168         require(balanceOf[_to] + _value > balanceOf[_to]);
169         // Save this for an assertion in the future
170         uint previousBalances = balanceOf[_from] + balanceOf[_to];
171         // Subtract from the sender
172         balanceOf[_from] -= _value;
173         // Add the same to the recipient
174         balanceOf[_to] += _value;
175         
176         if(isContract(_to))
177         {
178             ERC223Receiver receiver = ERC223Receiver(_to);
179             receiver.tokenFallback(msg.sender, _value, _data);
180         }
181         
182         Transfer(_from, _to, _value,_data);
183         // Asserts are used to use static analysis to find bugs in your code. They should never fail
184         assert(balanceOf[_from] + balanceOf[_to] == previousBalances);
185     }
186 
187    
188 
189     /// @notice Create `mintedAmount` tokens and send it to `target`
190     /// @param target Address to receive the tokens
191     /// @param givenAmount the amount of tokens it will receive
192     function giveToken(address target, uint256 givenAmount) onlyOwner public {
193          bytes memory empty;
194          balanceOf[owner] -= givenAmount;
195         balanceOf[target] += givenAmount;
196         Transfer(owner, target, givenAmount,empty);
197 
198 
199     }
200     /// @notice Allow users to buy tokens for `newBuyPrice` eth and sell tokens for `newSellPrice` eth
201     /// @param newSellPrice Price the users can sell to the contract
202     /// @param newBuyPrice Price users can buy from the contract
203     function setPrices(uint256 newSellPrice, uint256 newBuyPrice) onlyOwner public {
204         sellPrice = newSellPrice;
205         buyPrice = newBuyPrice;
206     }
207     
208      function withdraw() onlyOwner public {
209         owner.transfer(this.balance);
210     }
211     
212 
213      function() public payable  {
214          require(buyPrice >0);
215           bytes memory empty;
216         // Buy(msg.sender, msg.value);
217        // uint amount = msg.value * buyPrice; 
218        // balanceOf[msg.sender] +=( msg.value * buyPrice);                         // Subtract from the sender
219         //balanceOf[owner] -= -msg.value * buyPrice;// calculates the amount
220         _transfer(owner, msg.sender, msg.value * buyPrice,empty);
221        //owner.transfer(msg.value);
222         
223     }
224 
225     /// @notice Sell `amount` tokens to contract
226     /// @param amount amount of tokens to be sold
227     function sell(uint256 amount) public {
228         require(sellPrice >0);
229          bytes memory empty;
230         require(this.balance >= amount / sellPrice);      // checks if the contract has enough ether to buy
231         _transfer(msg.sender, owner, amount,empty);              // makes the transfers
232         //msg.sender.transfer(amount / sellPrice);          // sends ether to the seller. It's important to do this last to avoid recursion attacks
233     }
234     
235     
236 }