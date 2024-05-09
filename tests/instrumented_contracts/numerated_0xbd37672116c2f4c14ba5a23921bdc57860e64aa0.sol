1 contract WavesPresale {
2     address public owner;
3     
4     struct Sale
5     {
6         uint amount;
7         uint date;
8     }
9 
10     mapping (bytes16 => Sale) public sales;
11     uint32 public numberOfSales;
12     uint public totalTokens;
13 
14     function WavesPresale() {
15         owner = msg.sender;
16         numberOfSales = 0;
17     }
18 
19     function changeOwner(address newOwner) {
20         if (msg.sender != owner) return;
21 
22         owner = newOwner;
23     }
24 
25     function newSale(bytes16 txidHash, uint amount, uint timestamp) {
26         if (msg.sender != owner) return;
27 
28         sales[txidHash] = Sale({
29                 amount: amount,
30                 date: timestamp
31             });
32         numberOfSales += 1;
33         totalTokens += amount;
34     }
35 
36     function getSaleDate(bytes16 txidHash) constant returns (uint, uint) {
37     	return (sales[txidHash].amount, sales[txidHash].date);
38     }
39 
40     function () {
41         // This function gets executed if a
42         // transaction with invalid data is sent to
43         // the contract or just ether without data.
44         // We revert the send so that no-one
45         // accidentally loses money when using the
46         // contract.
47         throw;
48     }
49 
50 }