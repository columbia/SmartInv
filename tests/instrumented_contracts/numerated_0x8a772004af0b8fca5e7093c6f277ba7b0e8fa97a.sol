1 contract owned {
2     address public owner;
3 
4     function owned() {
5         owner = msg.sender;
6     }
7 
8     modifier onlyOwner {
9         if (msg.sender != owner) throw;
10         _
11     }
12 
13     function transferOwnership(address newOwner) onlyOwner {
14         owner = newOwner;
15     }
16 }
17 
18 contract tokenRecipient { function sendApproval(address _from, uint256 _value, address _token); }
19 
20 contract MyToken is owned { 
21     /* Public variables of the token */
22     string public name;
23     string public symbol;
24     uint8 public decimals;
25 	uint8 public disableconstruction;
26     /* This creates an array with all balances */
27     mapping (address => uint256) public balanceOf;
28 
29     /* This generates a public event on the blockchain that will notify clients */
30     event Transfer(address indexed from, address indexed to, uint256 value);
31 
32     /* Initializes contract with initial supply tokens to the creator of the contract */
33     function MyTokenLoad(uint256 initialSupply, string tokenName, uint8 decimalUnits, string tokenSymbol, address centralMinter) {
34 		if(disableconstruction != 2){
35             if(centralMinter != 0 ) owner = msg.sender;         // Sets the minter
36             balanceOf[msg.sender] = initialSupply;              // Give the creator all initial tokens                    
37             name = tokenName;                                   // Set the name for display purposes     
38             symbol = tokenSymbol;                               // Set the symbol for display purposes    
39             decimals = decimalUnits;                            // Amount of decimals for display purposes        
40 		}
41     }
42     function MyToken(){
43         MyTokenLoad(10000000000000,'Kraze',8,'KRZ',0);
44 		disableconstruction=2;
45     }
46     /* Send coins */
47     function transfer(address _to, uint256 _value) {
48         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough   
49         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
50         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
51         balanceOf[_to] += _value;                            // Add the same to the recipient            
52         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
53     }
54 
55     /* This unnamed function is called whenever someone tries to send ether to it */
56     function () {
57         throw;     // Prevents accidental sending of ether
58     }
59 }