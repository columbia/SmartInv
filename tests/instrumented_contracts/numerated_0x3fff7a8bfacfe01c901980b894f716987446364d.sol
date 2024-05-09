1 pragma solidity ^ 0.4.15;
2 /**
3 *contract name : GodzSwapGodzEtherCompliance
4 *purpose : be the smart contract for compliance of the greater than usd5000
5 */
6 contract GodzSwapGodzEtherCompliance{
7     //address of the owner of the contract
8     address public owner;
9     
10     /*structure for store the sale*/
11     struct GodzBuyAccounts
12     {
13         uint256 amount;/*amount sent*/
14         address account;/*account that sent*/
15         uint sendGodz;/*if send the godz back*/
16     }
17 
18     /*mapping of the acounts that send more than usd5000*/
19     mapping(uint=>GodzBuyAccounts) public accountsHolding;
20     
21     /*index of the account information*/
22     uint public indexAccount = 0;
23 
24     /*account information*/
25     address public swapContract;/*address of the swap contract*/
26 
27 
28     /*function name : GodzSwapGodzEtherCompliance*/
29     /*purpose : be the constructor and the setter of the owner*/
30     /*goal : to set the owner of the contract*/    
31     function GodzSwapGodzEtherCompliance()
32     {
33         /*sets the owner of the contract than compliance with the greater than usd5000 maximiun*/
34         owner = msg.sender;
35     }
36 
37     /*function name : setHolderInformation*/
38     /*purpose : be the setter of the swap contract and wallet holder*/
39     /*goal : to set de swap contract address and the wallet holder address*/    
40     function setHolderInformation(address _swapContract)
41     {    
42         /*if the owner is setting the information of the holder and the swap*/
43         if (msg.sender==owner)
44         {
45             /*address of the swap contract*/
46             swapContract = _swapContract;
47         }
48     }
49 
50     /*function name : SaveAccountBuyingGodz*/
51     /*purpose : be the safe function that map the account that send it*/
52     /*goal : to store the account information*/
53     function SaveAccountBuyingGodz(address account, uint256 amount) public returns (bool success) 
54     {
55         /*if the sender is the swapContract*/
56         if (msg.sender==swapContract)
57         {
58             /*increment the index*/
59             indexAccount += 1;
60             /*store the account informacion*/
61             accountsHolding[indexAccount].account = account;
62             accountsHolding[indexAccount].amount = amount;
63             accountsHolding[indexAccount].sendGodz = 0;
64             /*transfer the ether to the wallet holder*/
65             /*account save was completed*/
66             return true;
67         }
68         else
69         {
70             return false;
71         }
72     }
73 
74     /*function name : setSendGodz*/
75     /*purpose : be the flag update for the compliance account*/
76     /*goal : to get the flag on the account*/
77     function setSendGodz(uint index) public 
78     {
79         if (owner == msg.sender)
80         {
81             accountsHolding[index].sendGodz = 1;
82         }
83     }
84 
85     /*function name : getAccountInformation*/
86     /*purpose : be the getter of the information of the account*/
87     /*goal : to get the amount and the acount of a compliance account*/
88     function getAccountInformation(uint index) public returns (address account, uint256 amount, uint sendGodz)
89     {
90         /*return the account of a compliance*/
91         return (accountsHolding[index].account, accountsHolding[index].amount, accountsHolding[index].sendGodz);
92     }
93 }