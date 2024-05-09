1 pragma solidity ^0.4.16; 
2 interface tokenRecipient { function receiveApproval(address _from, uint256 _value, address _token, bytes _extraData) public; } 
3 contract TokenERC20 { 
4     // Public variables of the token
5     string public name; 
6     string public symbol;
7     uint8 public decimals = 18; // 18 decimals is the strongly suggested default, avoid changing it 
8     uint256 public totalSupply; // This creates an array with all balances 
9     mapping (address => uint256) public balanceOf; 
10     mapping (address => mapping (address => uint256)) public allowance; 
11     // This generates a public event on the blockchain that will notify clients 
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     // This notifies clients about the amount burnt
14     event Burn(address indexed from, uint256 value); 
15     /** * Constrctor function * * Initializes contract with initial supply tokens to the creator of the contract */ 
16     function TokenERC20( uint256 initialSupply, string tokenName, string tokenSymbol ) public
17     { totalSupply = initialSupply * 10 ** uint256(decimals); 
18     // Update total supply with the decimal amount
19     balanceOf[msg.sender] = totalSupply; 
20     // Give the creator all initial  tokens
21     name = tokenName; 
22     // Set the name for display     purposes 
23     symbol = tokenSymbol; // Set the  symbol for display purposes 
24     } 
25     
26     /** * Internal transfer, only can be called by this contract */ 
27     function _transfer(address _from, address _to, uint _value) internal {
28         // Prevent transfer to 0x0 address.         Use burn() instead 
29         require(_to != 0x0);
30         // Check if the sender has enough 
31         require(balanceOf[_from] >= _value); 
32         // Check for overflows
33         require(balanceOf[_to] + _value > balanceOf[_to]);
34         // Save this for an assertion in the future
35         uint previousBalances = balanceOf[_from] + balanceOf[_to]; 
36         // Subtract from the sender 
37         balanceOf[_from] -= _value; 
38         // Add the same to the recipient 
39         balanceOf[_to] += _value; Transfer(_from, _to, _value); 
40         // Asserts are used to use static analysis to find bugs in your code. They should never fail
41         assert(balanceOf[_from] + balanceOf[_to] == previousBalances); }
42         /** * Transfer tokens * * Send `_value` tokens to `_to` from your account * * @param _to The address of the recipient * @param _value the amount to send */ 
43         function transfer(address _to, uint256 _value) public { _transfer(msg.sender, _to, _value); }
44         /** * Transfer tokens from other address * * Send `_value` tokens to `_to` on behalf of `_from` * * @param _from The address of the sender * @param _to The address of the recipient * @param _value the amount to send */
45         function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) { require(_value <= allowance[_from][msg.sender]);
46         // Check allowance 
47         allowance[_from][msg.sender] -= _value; 
48         _transfer(_from, _to, _value); return true; }
49         /** * Set allowance for other address * * Allows `_spender` to spend no more than `_value` tokens on your behalf * * @param _spender The address authorized to spend * @param _value the max amount they can spend */ 
50         function approve(address _spender, uint256 _value) public returns (bool success) { allowance[msg.sender][_spender] = _value; return true; }
51         /** * Set allowance for other address and notify * * Allows `_spender` to spend no more than `_value` tokens on your behalf, and then ping the contract about it * * @param _spender The address authorized to spend * @param _value the max amount they can spend * @param _extraData some extra information to send to the approved contract */ 
52         function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) { tokenRecipient spender = tokenRecipient(_spender); if (approve(_spender, _value)) { spender.receiveApproval(msg.sender, _value, this, _extraData); return true; } } 
53         /** * Destroy tokens * * Remove `_value` tokens from the system irreversibly * * @param _value the amount of money to burn */ 
54         function burn(uint256 _value) public returns (bool success) { require(balanceOf[msg.sender] >= _value); 
55         // Check if the sender has enough
56         balanceOf[msg.sender] -= _value; 
57         // Subtract from the sender
58         totalSupply -= _value; 
59         // Updates totalSupply 
60         Burn(msg.sender, _value); return true; }
61         /** * Destroy tokens from other account * * Remove `_value` tokens from the system irreversibly on behalf of `_from`. * * @param _from the address of the sender * @param _value the amount of money to burn */ 
62         function burnFrom(address _from, uint256 _value) public returns (bool success) { require(balanceOf[_from] >= _value);
63         // Check if the targeted balance is enough
64         require(_value <= allowance[_from][msg.sender]); 
65         // Check allowance 
66         balanceOf[_from] -= _value;
67         // Subtract from the targeted balance 
68         allowance[_from][msg.sender] -= _value; 
69         // Subtract from the sender's allowance 
70         totalSupply -= _value;
71         // Update totalSupply
72         Burn(_from, _value); return true; } }