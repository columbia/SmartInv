1 /*
2     This contracts holds the JamCoin. 
3 */
4 
5 
6 contract JamCoin { 
7     /* Public variables of the token */
8     string public name;
9     string public symbol;
10     uint8 public decimals;
11     
12     /* This creates an array with all balances */
13     mapping (address => uint256) public balanceOf;
14     
15     /* This generates a public event on the blockchain that will notify clients */
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     
18     /* Initializes contract with initial supply tokens to the creator of the contract */
19     function JamCoin() {
20         /* Unless you add other functions these variables will never change */
21         balanceOf[msg.sender] = 10000;
22         name = "Jam Coin";     
23         symbol = "5ea56e7bfd92b168fc18e421da0088bf";
24         decimals = 2;
25     }
26 
27     /* Send coins */
28     function transfer(address _to, uint256 _value) {
29         /* if the sender doenst have enough balance then stop */
30         if (balanceOf[msg.sender] < _value) throw;
31         if (balanceOf[_to] + _value < balanceOf[_to]) throw;
32         
33         /* Add and subtract new balances */
34         balanceOf[msg.sender] -= _value;
35         balanceOf[_to] += _value;
36         
37         /* Notifiy anyone listening that this transfer took place */
38         Transfer(msg.sender, _to, _value);
39     }
40 }