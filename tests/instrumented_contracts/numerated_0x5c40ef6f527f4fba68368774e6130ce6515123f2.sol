1 contract ExtraBalToken {
2     uint256 public totalSupply;
3 
4     /* This creates an array with all balances */
5     mapping (address => uint256) public balanceOf;
6     mapping (address => mapping (address => uint256)) public allowance;
7 
8     /* This generates a public event on the blockchain that will notify clients */
9     event Transfer(address indexed from, address indexed to, uint256 value);
10 
11     /* Send coins */
12     function transfer(address _to, uint256 _value) {
13         if (balanceOf[msg.sender] < _value) throw;           // Check if the sender has enough
14         if (balanceOf[_to] + _value < balanceOf[_to]) throw; // Check for overflows
15         balanceOf[msg.sender] -= _value;                     // Subtract from the sender
16         balanceOf[_to] += _value;                            // Add the same to the recipient
17         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
18     }
19 
20     /* Allow another contract to spend some tokens in your behalf */
21     function approve(address _spender, uint256 _value)
22         returns (bool success) {
23         allowance[msg.sender][_spender] = _value;
24         return true;
25     }
26 
27     /* A contract attempts to get the coins */
28     function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {
29         if (balanceOf[_from] < _value) throw;                 // Check if the sender has enough
30         if (balanceOf[_to] + _value < balanceOf[_to]) throw;  // Check for overflows
31         if (_value > allowance[_from][msg.sender]) throw;   // Check allowance
32         balanceOf[_from] -= _value;                          // Subtract from the sender
33         balanceOf[_to] += _value;                            // Add the same to the recipient
34         allowance[_from][msg.sender] -= _value;
35         Transfer(_from, _to, _value);
36         return true;
37     }
38 
39     /* This unnamed function is called whenever someone tries to send ether to it */
40     function () {
41         throw;     // Prevents accidental sending of ether
42     }
43 
44     uint constant D160 = 0x10000000000000000000000000000000000000000;
45 
46     address public owner;
47 
48     function ExtraBalToken() {
49         owner = msg.sender;
50     }
51 
52     bool public sealed;
53     // The 160 LSB is the address of the balance
54     // The 96 MSB is the balance of that address.
55     function fill(uint[] data) {
56         if ((msg.sender != owner)||(sealed))
57             throw;
58 
59         for (uint i=0; i<data.length; i++) {
60             address a = address( data[i] & (D160-1) );
61             uint amount = data[i] / D160;
62             if (balanceOf[a] == 0) {   // In case it's filled two times, it only increments once
63                 balanceOf[a] = amount;
64                 totalSupply += amount;
65             }
66         }
67     }
68 
69     function seal() {
70         if ((msg.sender != owner)||(sealed))
71             throw;
72 
73         sealed= true;
74     }
75 
76 }