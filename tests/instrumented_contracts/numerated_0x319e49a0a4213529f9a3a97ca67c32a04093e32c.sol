1 pragma solidity ^0.4.24;
2 
3 contract Ownable {}
4 contract CREDITS is Ownable{}
5 contract CREDITCoins is CREDITS{
6     bool public Frozen;
7     mapping(address => bool) public AccountIsFrozen;
8     mapping(address => bool) public AccountIsNotFrozen;
9     mapping(address => uint) public AccountIsFrozenByDate;
10     mapping(address => uint256) public balanceOf;
11     mapping (address => bool) public isHolder;
12     address [] public Arrholders;
13     mapping(address => bool) public AccountIsNotFrozenForReturn;
14     address public AddressForReturn;
15     
16     function transfer(address _to, uint256 _value) public;
17 }
18 
19 contract ContractSendCreditCoins {
20     //storage
21     CREDITCoins public company_token;
22     address public PartnerAccount;
23   
24     //Events
25     event Transfer(address indexed to, uint indexed value);
26 
27     //constructor
28     constructor (CREDITCoins _company_token) public {
29         PartnerAccount = 0x4f89aaCC3915132EcE2E0Fef02036c0F33879eA8;
30         company_token = _company_token;
31     }
32   
33     function sendCurrentPayment() public {  
34             company_token.transfer(PartnerAccount, 1);
35             emit Transfer(PartnerAccount, 1);
36     }
37 }