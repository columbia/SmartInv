1 pragma solidity ^0.4.18;
2 
3 // See ethermango.com
4 // Sell digital products easily, only 1% fees
5 contract EtherMango {
6     
7     uint public feePercent = 100;
8     address owner;
9     uint public numProducts;
10     mapping(uint => Product) public products;
11     mapping(address => mapping(uint => bool)) public purchases;
12 
13     event ProductAdded(uint productId, address merchant, uint price);
14     event ProductPurchased(uint productId, address buyer);
15     
16     struct Product {
17         uint price;
18         address merchant;
19         bool isFrozen;
20     }
21     
22     function EtherMango() public payable {
23         owner = msg.sender;
24     }
25     
26     function AddProduct(uint price) public payable returns(uint productId) {
27         productId = numProducts++;
28 
29         products[productId] = Product(price, msg.sender, false);
30         // Merchant auto purchases their own product
31         purchases[msg.sender][productId] = true;
32         ProductAdded(productId, msg.sender, price);
33     }
34     
35     function Pay(uint productId) public payable {
36         require(products[productId].price == msg.value);
37         require(products[productId].isFrozen == false);
38 
39         uint fee = msg.value / feePercent;
40         uint remaining = msg.value - fee;
41         // Immediately pay out merchant, but keep fees in contract
42         // Which keeps the gas cost lower
43         products[productId].merchant.transfer(remaining);
44         
45         // Log the purchase on the blockchain
46         purchases[msg.sender][productId] = true;
47         ProductPurchased(productId, msg.sender);
48     }
49     
50     function WithdrawFees() public payable {
51         require(msg.sender == owner);
52         owner.transfer(this.balance);
53     }
54 
55     function FreezeProduct(uint productId) public {
56         require(products[productId].merchant == msg.sender);
57         products[productId].isFrozen = true;
58     }
59     
60     function UnFreezeProduct(uint productId) public {
61         require(products[productId].merchant == msg.sender);
62         products[productId].isFrozen = false;
63     }
64 }