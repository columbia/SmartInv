1 pragma solidity ^0.4.10;
2 
3 contract Loan {
4     uint8 public constant STATUS_INITIAL = 1;
5     uint8 public constant STATUS_LENT = 2;
6     uint8 public constant STATUS_PAID = 3;
7 
8     string public versionCode;
9     
10     address public borrower;
11     address public lender;
12 
13     uint8 public status;
14 
15     uint256 public amount;
16     uint256 public paid;
17 
18     event ApprovedBy(address _address);
19     event DestroyedBy(address _address);
20     event PartialPayment(address _sender, address _from, uint256 _amount);
21     event Transfer(address _from, address _to);
22     event TotalPayment();
23 
24     function pay(uint256 _amount, address _from);
25     function destroy();
26     function lend();
27     function approve();
28     function isApproved() returns (bool);
29 }
30 
31 contract LoanDirectory {
32     Loan[] public loans;
33 
34     function registerLoan(Loan loan) {
35         require(loan.status() == loan.STATUS_INITIAL()); // Check if loan implements Loan interface
36         loans.push(loan);
37     }
38     
39     function registerLoanReplace(Loan loan, uint256 indexReplace) {
40         require(indexReplace < loans.length);
41         Loan replaceLoan = loans[indexReplace]; // Get loan to delete
42         require(replaceLoan.status() != replaceLoan.STATUS_INITIAL());
43         require(loan.status() == loan.STATUS_INITIAL());
44         loans[indexReplace] = loan;
45     }
46 
47     function registerLoanReplaceDuplicated(Loan loan, uint256 replaceA, uint256 replaceB) {
48         require(replaceA < loans.length && replaceB < loans.length);
49         require(replaceA != replaceB);
50         require(loans[replaceA] == loans[replaceB]);
51         require(loan.status() == loan.STATUS_INITIAL());
52         loans[replaceA] = loan;
53     }
54 
55     function getAllLoans() constant returns (Loan[]) {
56         return loans;
57     }
58 }