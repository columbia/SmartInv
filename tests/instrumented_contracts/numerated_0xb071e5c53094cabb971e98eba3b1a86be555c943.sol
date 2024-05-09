1 contract IOU {
2     address owner;
3 
4 /* Public variables of the token */
5     string public name;
6     string public symbol;
7     uint8 public decimals;
8     
9 /* This creates an array with all balances */
10     mapping (address => uint256) public balanceOf;
11 
12 /* This generates a public event on the blockchain that will notify clients */
13 event Transfer(address indexed from, address indexed to, uint256 value);
14 
15     function IOU(string tokenName, string tokenSymbol, uint8 decimalUnits) {
16         owner = msg.sender;                                 // sets main RipplePay contract as owner
17         name = tokenName;                                       // Set the name for display purposes     
18         symbol = tokenSymbol;                                     // Set the symbol for display purposes    
19         decimals = decimalUnits;                                       // Amount of decimals for display purposes        
20     
21     }
22     
23     /* update balances so they display in ethereum-wallet */
24     function transfer(address _from, address _to, uint256 _value) {
25         if(msg.sender != owner) throw;                       // can only be invoked by main RipplePay contract
26         balanceOf[_from] -= _value;                     // Subtract from the sender
27         balanceOf[_to] += _value;                            // Add the same to the recipient
28         Transfer(msg.sender, _to, _value);                   // Notify anyone listening that this transfer took place
29     }
30     
31 }
32 
33 
34 
35 contract RipplePayMain {
36 
37 mapping(string => address) currencies;
38 
39 function newCurrency(string currencyName, string currencySymbol, uint8 decimalUnits){
40 currencies[currencySymbol] = new IOU(currencyName, currencySymbol, decimalUnits);
41 }
42 
43 function issueIOU(string _currency, uint256 _amount, address _to){
44     // update creditLines in main contract, then update balances in IOU contract to display in ethereum-wallet
45     IOU(currencies[_currency]).transfer(msg.sender, _to, _amount);
46 
47 }
48 
49 }