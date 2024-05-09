1 contract BEXP {  
2     /* This creates an array with all balances */  
3     mapping (address => uint256) public balanceOf;
4       
5     string public name = "BitExpress";  
6     string public symbol = "BEXP";  
7     uint8 public decimals = 8;  
8     uint256 public totalSupply = 1000000000 * 10**8;
9     address founder = address(0xe2ce6a2539efbdf0a211300aadb70a416d5d2bec);
10       
11     event Transfer(address indexed from, address indexed to, uint256 value);  
12           
13     /* Initializes contract with initial supply tokens to the creator of the contract */  
14     function BEXP () public {  
15         balanceOf[founder] = totalSupply ;             // Give the creator all initial tokens  
16         Transfer(0, founder, totalSupply);
17     }  
18           
19     function transfer(address _to, uint256 _value) public returns (bool success){  
20         /* Check if sender has balance and for overflows */  
21         require(balanceOf[msg.sender] >= _value && balanceOf[_to] + _value >= balanceOf[_to]);  
22   
23         /* Add and subtract new balances */  
24         balanceOf[msg.sender] -= _value;  
25         balanceOf[_to] += _value;  
26           
27         /* Notify anyone listening that this transfer took place */  
28         Transfer(msg.sender, _to, _value);
29         
30         return true;
31     }
32 }