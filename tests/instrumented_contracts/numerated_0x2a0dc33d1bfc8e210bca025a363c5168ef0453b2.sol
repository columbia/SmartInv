1 pragma solidity ^0.4.18;
2 
3 contract GiftCard2017{
4     address owner;
5     mapping (address => uint256) public authorizations;
6     
7     /// Constructor sets owner.
8     function GiftCard2017() public {
9         owner = msg.sender;
10     }
11     
12     /// Redeems authorized ETH.
13     function () public {
14         uint256 _redemption = authorizations[msg.sender];   // Amount mEth available to redeem.
15         require (_redemption > 0);
16         authorizations[msg.sender] = 0;                     // Clear authorization.
17         msg.sender.transfer(_redemption * 1e15);            // convert mEth to wei for transfer()
18     }
19     
20     /// Contract owner deposits ETH.
21     function deposit() public payable OwnerOnly {
22     }
23     
24     /// Contract owner withdraws ETH.
25     function withdraw(uint256 _amount) public OwnerOnly {
26         owner.transfer(_amount);
27     }
28 
29     /// Contract owner authorizes redemptions in units of 1/1000 ETH.    
30     function authorize(address _addr, uint256 _amount_mEth) public OwnerOnly {
31         require (this.balance >= _amount_mEth);
32         authorizations[_addr] = _amount_mEth;
33     }
34     
35     /// Check that message came from the contract owner.
36     modifier OwnerOnly () {
37         require (msg.sender == owner);
38         _;
39     }
40 }