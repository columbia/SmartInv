1 contract DAO {
2     function balanceOf(address addr) returns (uint);
3     function transferFrom(address from, address to, uint balance) returns (bool);
4     uint public totalSupply;
5 }
6 
7 contract WithdrawDAO {
8     DAO constant public mainDAO = DAO(0xbb9bc244d798123fde783fcc1c72d3bb8c189413);
9     address public trustee = 0xcdf7D2D0BdF3511FFf511C62f3C218CF98A136eB; // to be replaced by a multisig
10 
11     function withdraw(){
12         uint balance = mainDAO.balanceOf(msg.sender);
13 
14         if (!mainDAO.transferFrom(msg.sender, this, balance) || !msg.sender.send(balance))
15             throw;
16     }
17 
18     function trusteeWithdraw() {
19         trustee.send((this.balance + mainDAO.balanceOf(this)) - mainDAO.totalSupply());
20     }
21 }