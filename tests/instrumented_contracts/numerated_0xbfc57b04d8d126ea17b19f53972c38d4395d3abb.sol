1 pragma solidity ^0.4.25;
2 
3 contract DmDesignContract  {    
4 
5     string public constant name = "https://dm-design.pl"; 
6     string public constant facebook = "https://www.facebook.com/DmDesignPoland/"; 
7     string public description = "Indywidualność, to coś co nas wyróżnia!";
8     
9     address public owner_;
10     mapping (address => ProductItem) public product;
11     uint public totalProducts = 0;
12 
13     struct ProductItem {
14         uint confirm;
15         uint productNr;
16         uint addTime;
17         address owner;
18         string description;
19         string signature;
20         string productCode;
21     }
22     
23     constructor() public {
24         owner_ = msg.sender;
25     }
26     
27     modifier onlyOwner() {
28         require(msg.sender == owner_, "Not contract owner");
29         _;
30     }
31     
32     function updateDescription(string text) public onlyOwner returns (bool){
33         description = text;
34         return true;
35     }
36     
37     function changeContractOwner(address newOwner) public onlyOwner returns (bool){
38         owner_ = newOwner;
39         return true;
40     }    
41 
42     function addProduct(address productOwner, uint productNr, string productDescripion, string productCode, string signature) public onlyOwner returns (bool){
43         require(product[productOwner].owner == 0x0, "product already has owner");
44 
45         product[productOwner].owner = productOwner;
46         product[productOwner].confirm = 0;
47         product[productOwner].productNr = productNr;
48         product[productOwner].description = productDescripion;
49         product[productOwner].productCode = productCode;
50         product[productOwner].signature = signature;
51         product[productOwner].addTime = block.timestamp;
52         totalProducts++;
53     }
54 
55     function confirmProduct(uint confirmNr) public returns (bool){
56         product[msg.sender].confirm = confirmNr;
57     }
58 
59     function signProduct(string signatureOwner) public returns (bool){
60         require(product[msg.sender].owner != 0x0, "No produt for this address");
61 
62         product[msg.sender].signature = signatureOwner;        
63     }
64 
65     function resell(address buyer, string signature) public returns (bool){
66         require(product[buyer].owner == 0x0, "buyer already has other product use other address");
67         require(product[msg.sender].owner != 0x0, "seller has no product");
68 
69         product[buyer].owner = buyer;
70         product[buyer].confirm = 0;
71         product[buyer].productNr = product[msg.sender].productNr;
72         product[buyer].description = product[msg.sender].description;
73         product[buyer].productCode = product[msg.sender].productCode;
74         product[buyer].addTime = product[msg.sender].addTime;
75         product[buyer].signature = signature;
76         
77         product[msg.sender].owner = 0x0;        
78         product[msg.sender].signature = "";     
79         product[msg.sender].productNr = 0;   
80         product[msg.sender].description = "";
81         product[msg.sender].productCode = "";
82         product[msg.sender].confirm = 0;
83         product[msg.sender].addTime = 0;
84     }
85 }