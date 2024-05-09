1 pragma solidity 0.5.12;
2 
3 contract FaucetPay {
4     
5     event Deposit(address _from, uint256 _amount);
6     event Withdrawal(address _to, uint256 _amount);
7     
8     address payable private adminAddress;
9      
10     constructor() public { 
11         adminAddress = msg.sender;
12     }
13     
14     modifier _onlyOwner(){
15         require(msg.sender == adminAddress);
16           _;
17     }
18 
19     function changeAdminAddress(address payable _newAddress) _onlyOwner public {
20         adminAddress = _newAddress;
21     }
22     
23     function () external payable {
24         deposit();
25     }
26 
27     function deposit() public payable returns(bool) {
28         
29         require(msg.value > 0);
30         emit Deposit(msg.sender, msg.value);
31         
32         return true;
33         
34     }
35 
36     function withdraw(address payable _address, uint256 _amount) _onlyOwner public returns(bool) {
37     
38         _address.transfer(_amount);
39         emit Withdrawal(_address, _amount);
40         
41         return true;
42         
43     }
44     
45     function withdrawMass(address[] memory _addresses, uint256[] memory _amounts) _onlyOwner public returns(bool) {
46         
47         for(uint256 i = 0; i < _addresses.length; i++) {
48             
49             address payable payable_address = address(uint160(_addresses[i]));
50             withdraw(payable_address, _amounts[i]);
51 	        
52 	    }
53 	    
54 	    return true;
55         
56     }
57     
58 }