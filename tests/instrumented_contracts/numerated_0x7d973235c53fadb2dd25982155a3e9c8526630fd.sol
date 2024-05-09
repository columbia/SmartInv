1 contract Daric {
2     /* Public variables of the token */
3     string public standard = 'Token 0.1';
4     string public name;
5     string public symbol;
6     uint8 public decimals;
7     uint256 public initialSupply;
8     uint256 public totalSupply;
9 
10     /* This creates an array with all balances */
11     mapping (address => uint256) public balanceOf;
12     mapping (address => mapping (address => uint256)) public allowance;
13 
14   
15     /* Initializes contract with initial supply tokens to the creator of the contract */
16     function Daric() {
17 
18          initialSupply = 110000000000000000000000000;
19          name ="Daric Coins";
20         decimals = 18;
21          symbol = "Daric";
22         
23         balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens
24         totalSupply = initialSupply;                        // Update total supply
25                                    
26     }
27 
28 
29      /* Send coins */
30     function transfer(address _to, uint256 _value) {
31         /* Add and subtract new balances */
32         balanceOf[msg.sender] -= _value;
33         balanceOf[_to] += _value;
34 
35         /* Check if sender has balance and for overflows */
36         require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);
37 
38         /* Add and subtract new balances */
39         balanceOf[msg.sender] -= _value;
40         balanceOf[_to] += _value;
41     }
42 
43 }