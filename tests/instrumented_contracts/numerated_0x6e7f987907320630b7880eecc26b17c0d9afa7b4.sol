1 contract ValidetherOracle {
2 
3   //  Name of the institution to Ethereum address of the institution
4   mapping (string => address) nameToAddress;
5     //  Ethereum address of the institution to Name of the institution
6   mapping (address => string) addressToName;
7 
8   address admin;
9 
10   modifier onlyAdmin {
11      if (msg.sender != admin) throw;
12      _
13   }
14 
15   /*
16     Constructor Function
17   */
18   function ValidetherOracle() {
19     admin = msg.sender;
20   }
21 
22   /*
23     Function which adds an institution
24     */
25   function addInstitution(address institutionAddress, string institutionName) onlyAdmin {
26     nameToAddress[institutionName] = institutionAddress;
27     addressToName[institutionAddress] = institutionName;
28   }
29 
30   /*
31     Function which validates an institution address and returns its name
32     @param institutionAddress Ethereum Address of the institution
33     @return "" if the address is not valid and the institution name if the address is valid.
34     */
35   function getInstitutionByAddress(address institutionAddress) constant returns(string) {
36     return addressToName[institutionAddress];
37   }
38 
39   /*
40     Function which validates an institution name and returns its address
41     @param institutionName Name of the institution
42     @return 0x0000000000000000000000000000000000000000 if the name is not valid and the institution Ethereum Address if the name is valid.
43   */
44   function getInstitutionByName(string institutionName) constant returns(address) {
45     return nameToAddress[institutionName];
46   }
47 
48   /*
49     Function which changes the admin address of the contract
50     @param newAdmin Ethereum address of the new admin
51   */
52   function setNewAdmin(address newAdmin) onlyAdmin {
53     admin = newAdmin;
54   }
55 
56 }