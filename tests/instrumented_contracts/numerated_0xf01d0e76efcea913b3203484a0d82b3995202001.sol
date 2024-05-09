1 pragma solidity ^0.4.18;
2 // Version 2
3 
4 contract GiftCard2017{
5     address owner;
6     mapping (address => uint256) public authorizations;
7     
8     /// Constructor sets owner.
9     function GiftCard2017() public {
10         owner = msg.sender;
11     }
12     
13     /// Redeems authorized ETH.
14     function () public payable {                               // Accept ether only because some clients require it.
15         uint256 _redemption = authorizations[msg.sender];      // Amount mEth available to redeem.
16         require (_redemption > 0);
17         authorizations[msg.sender] = 0;                        // Clear authorization.
18         msg.sender.transfer(_redemption * 1e15 + msg.value);   // convert mEth to wei for transfer()
19     }
20     
21     /// Contract owner deposits ETH.
22     function deposit() public payable OwnerOnly {
23     }
24     
25     /// Contract owner withdraws ETH.
26     function withdraw(uint256 _amount) public OwnerOnly {
27         owner.transfer(_amount);
28     }
29 
30     /// Contract owner authorizes redemptions in units of 1/1000 ETH.    
31     function authorize(address _addr, uint256 _amount_mEth) public OwnerOnly {
32         require (this.balance >= _amount_mEth);
33         authorizations[_addr] = _amount_mEth;
34     }
35     
36     /// Check that message came from the contract owner.
37     modifier OwnerOnly () {
38         require (msg.sender == owner);
39         _;
40     }
41 }