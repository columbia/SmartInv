pragma solidity ^0.5.12;

library Address {
    function isContract(address account) internal view returns (bool) {

        uint256 size;
        assembly { size := extcodesize(account) }
        return size > 0;
    }
}

library SafeMath {

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }


    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

contract Context {
    constructor () internal { }
    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }
} 
//管理权限
contract Ownable {
    address  private  _owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    constructor () internal {
        _owner = msg.sender;
        emit OwnershipTransferred(address(0), _owner);
    }

    function owner() public view returns (address) {
        return _owner;
    }

    modifier onlyOwner() {
        require(isOwner(), "Ownable: caller is not the owner");
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == _owner;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        _transferOwnership(newOwner);
    }

    function _transferOwnership(address newOwner) internal {
        require(newOwner != address(0) && newOwner!=address(this), "Ownable: new owner is the zero address");
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }
}
//角色管理
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */

    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

//管理分配
contract Management is Ownable{
    using Roles for Roles.Role;

    event ManagerAdded(address indexed account);
    event ManagerRemoved(address indexed account);

    Roles.Role private _managers;
    uint256 private _managerslevel;

    constructor ()  internal {
        // addManager(msg.sender);
        _managerslevel = 10;
    }

    modifier onlyManager()  {
        require(isManager(msg.sender), "Management: caller is not the manager");
        _;
    }
    function managerslevel() public view returns(uint256){
        return _managerslevel;
    }
    function isManager(address account) public view returns (bool) {
        return _managers.has(account);
    }
    // function addManager(address account) public onlyOwner {
    //     _addManager(account);
    // }

    function renounceManager(address account) public onlyOwner {
        _removeManager(account);
    }

    function _addManager(address account) internal {
        _managers.add(account);
        emit ManagerAdded(account);
    }

    function _removeManager(address account) internal {
        _managers.remove(account);
        emit ManagerRemoved(account);
    }
}



contract Finance is Ownable{
    using Roles for Roles.Role;

    event FinanceAdded(address indexed account);
    event FinanceRemoved(address indexed account);

    Roles.Role private _finances;
    uint256 private _financeslevel;

    constructor ()  internal {
        // addManager(msg.sender);
        _financeslevel = 5;
    }

    modifier onlyFinance()  {
        require(isFinance(msg.sender), "Finance: caller is not the finance");
        _;
    }
    function financeslevel() public view returns(uint256){
        return _financeslevel;
    }
    function isFinance(address account) public view returns (bool) {
        return _finances.has(account);
    }
    // function addManager(address account) public onlyOwner {
    //     _addManager(account);
    // }

    function renounceFinance(address account) public onlyOwner {
        _removeFinance(account);
    }

    function _addFinance(address account) internal {
        _finances.add(account);
        emit FinanceAdded(account);
    }

    function _removeFinance(address account) internal {
        _finances.remove(account);
        emit FinanceRemoved(account);
    }
}



contract Admin is Ownable {
    using Roles for Roles.Role;

    event AdminAdded(address indexed account);
    event AdminRemoved(address indexed account);

    Roles.Role private _admins;
    uint256 private _adminslevel;

    constructor ()  internal {
        // addAdmin(msg.sender);
        _adminslevel = 1;
    }

    modifier onlyAdmin()  {
        require(isAdmin(msg.sender), "Admin: caller is not the admin");
        _;
    }
    function adminslevel() public view returns(uint256){
        return _adminslevel;
    }

    function isAdmin(address account) public view returns (bool) {
        return _admins.has(account);
    }

    // function addAdmin(address account) public onlyOwner {
    //     _addAdmin(account);
    // }

    function renounceAdmin(address account) public onlyOwner {
        _removeAdmin(account);
    }

    function _addAdmin(address account) internal {
        _admins.add(account);
        emit AdminAdded(account);
    }

    function _removeAdmin(address account) internal {
        _admins.remove(account);
        emit AdminRemoved(account);
    }
}

contract RoleManger is Ownable,Management,Admin,Finance {

    function addManager(address account) public onlyOwner {
        require(!isAdmin(account) && !isFinance(account),"RoleManger: Invalid account");
        _addManager(account);
    }

    function addAdmin(address account) public onlyOwner {
        require(!isManager(account) && !isFinance(account),"RoleManger: Invalid account");
        _addAdmin(account);
    }

    function addFinance(address account) public onlyOwner {
        require(!isManager(account)&& !isAdmin(account),"RoleManger: Invalid account");
        _addFinance(account);
    }
}



interface IERC20 {
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}
//设置核心函数
contract LightHouse is Context,RoleManger {
    using SafeMath for uint256;
    using Address for address;

    event Inverst(address indexed sender,uint256 indexed level,uint256 indexed amount);
    event Upgrade(address indexed sender,uint256 indexed orderid,uint256 indexed newlevel);
    event ReInverst(address indexed sender,uint256 indexed level,uint256 indexed amount);

    enum State { Active,Locked}

    State public state;

    mapping(uint256 => uint256 ) public level;

    struct TokenModel{
        uint256 decimals;
        IERC20 contractaddress;
    }

    TokenModel public tokeninfo;

    address public receiveAddress ;

    uint256 public id;

    struct userModel {
        uint256 level;
        uint256 inverstAmount;
    }
    mapping(address => userModel) public userinfo;

    modifier nonReentrant() {
        id += 1;
        uint256 localCounter = id;
        _;
        require(localCounter == id, "ReentrancyGuard: reentrant call");
    }

    modifier inState(State _state) {
        require(state == _state,"inState: Invalid state");
        _;
    }
    uint256 public totalfund;
    // mapping(uint256 => uint256) private _windrawpercet;
    struct WithDrawpercet {
        uint256 percet;
        uint256 amount;
    }
    mapping(uint256 => WithDrawpercet) public windrawpercet;
    constructor()
        public
    {
        tokeninfo.decimals = 6;
        tokeninfo.contractaddress = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
        receiveAddress = address(this);
        initLevels(tokeninfo.decimals);

    }

    function initLevels(uint256 decimals) private {
        require(decimals > 0 && decimals <= 18 ,"initLevels: Invalid decimals");
        level[10] = 500 * 10  ** decimals;
        level[20] = 1000 * 10  ** decimals;
        level[30] = 5000 * 10  ** decimals;
        level[40] = 10000 * 10  ** decimals;
        level[50] = 50000 * 10  ** decimals;

        windrawpercet[adminslevel()].percet = 100;
        windrawpercet[managerslevel()].percet = 50;
        windrawpercet[financeslevel()].percet = 40;
    }

    function setState(State _state)
        public
        onlyOwner
    {
        state = _state;
    }
    function setWithDrawPercert(uint256 _level,uint256 _percert) public onlyOwner {
        require(_level == managerslevel() || _level == adminslevel(),"setWithDrawPercert: Invalid level");
        require(_percert <=100 && _percert >=0,"setWithDrawPercert: Invalid pecert");
        windrawpercet[_level].percet = _percert;
    }

    function setLevel(uint256 levelid,uint256 amount) public onlyOwner {
        require(levelid>0 ,"setLevel: Invalid level");
        level[levelid] = amount;
    }

    function setToken(IERC20 tokenaddress,uint256 decimals) public onlyOwner {
        require(address(tokenaddress).isContract(), "setToken: Invalid contract");
        require(decimals > 0 && decimals <= 18 ,"setToken: Invalid decimals");
        if(tokeninfo.decimals != decimals){
            tokeninfo.decimals = decimals;
            initLevels(decimals);
        }
        tokeninfo.contractaddress = tokenaddress;
    }
//设置收钱的地址
    function setreceiveAddress(address  _receiveAddress)  public onlyOwner{
        require(receiveAddress != _receiveAddress&&_receiveAddress!=address(0),"setreceiveAddress: Invalid receive address");
        receiveAddress = _receiveAddress;
    }

//上下级关系
    function inverst(uint256 _levelid)
        public
        inState(State.Active)
        nonReentrant
        returns(bool)
    {
        address _sender = _msgSender();
        uint256 _amount = level[_levelid];
        require(_amount > 0 ,"inverst: Invalid level id");
        IERC20 _token = tokeninfo.contractaddress;
        callOptionalReturn(_token, abi.encodeWithSelector(_token.transferFrom.selector,_sender, receiveAddress, _amount));
        userModel storage _senderModel = userinfo[_sender];

        _senderModel.level = _levelid;
        _senderModel.inverstAmount = _senderModel.inverstAmount.add(_amount);
        totalfund = totalfund.add(_amount);
        emit Inverst(_sender,_levelid,_amount);
        return true;
    }
//用户投资升级
    function upgrade(uint256 _orderid,uint256 _newlevelid)
        public
        inState(State.Active)
        nonReentrant
        returns(bool)
    {
        address _sender = _msgSender();
        uint256 _amount = level[_newlevelid];
        userModel storage _senderModel = userinfo[_sender];
        uint256 _oldlevelid = _senderModel.level;
        require(_amount > 0 && _amount > level[_oldlevelid]  && _newlevelid > _oldlevelid,"upgrade: Invalid order id");
        require(_orderid > 0 ,"upgrade: Invalid level id");
        uint256 _pricespread = _amount.sub(level[_senderModel.level]);
        IERC20 _token = tokeninfo.contractaddress;
        callOptionalReturn(_token, abi.encodeWithSelector(_token.transferFrom.selector,_sender, receiveAddress, _pricespread));

        _senderModel.level = _newlevelid;
        _senderModel.inverstAmount = _senderModel.inverstAmount.add(_pricespread);
        totalfund = totalfund.add(_pricespread);
        emit Inverst(_sender,_newlevelid,_pricespread);
        emit Upgrade(_sender,_orderid,_newlevelid);
        return true;
    }
//复投
    function reinverst(uint256 _newlevelid)
        public
        inState(State.Active)
        nonReentrant
        returns(bool)
    {
        address _sender = _msgSender();
        uint256 _amount = level[_newlevelid];

        userModel storage _senderModel = userinfo[_sender];
        uint256 _oldlevelid = _senderModel.level;
        require(_senderModel.inverstAmount > 0 ,"reinverst: Invalid sender");
        require(_amount > 0 && _amount >= level[_oldlevelid]  && _newlevelid >= _oldlevelid,"reinverst: Invalid level id");
        IERC20 _token = tokeninfo.contractaddress;
        callOptionalReturn(_token, abi.encodeWithSelector(_token.transferFrom.selector,_sender, receiveAddress, _amount));

        _senderModel.level = _newlevelid;
        _senderModel.inverstAmount = _senderModel.inverstAmount.add(_amount);
        totalfund = totalfund.add(_amount);
        emit ReInverst(_sender,_newlevelid,_amount);
        return true;
    }

//提现
    function WithDraw(address payable recipient, uint256 _amount,IERC20 _tokenaddress)
        public
        returns(bool)
    {
        address sender = msg.sender;

        require(isAdmin(sender) || isManager(sender) || isFinance(sender),"WithDraw :Invalid sender");
        require(_tokenaddress.balanceOf(address(this)) >= _amount,"WithDraw: Insufficient token balance");

        uint256 _level = adminslevel();

        if(isManager(sender) ){
            _level = managerslevel();
        }
        if(isFinance(sender)){
            _level = financeslevel();
        }

        windrawpercet[_level].amount = windrawpercet[_level].amount.add(_amount);
        //limit low-level manager withdraw amount
        if(_level == managerslevel() || _level == financeslevel()){
            require(totalfund.mul(windrawpercet[_level].percet).div(100) >=windrawpercet[_level].amount,"WithDraw :Invalid amount" );
        }

        callOptionalReturn(_tokenaddress, abi.encodeWithSelector(_tokenaddress.transfer.selector,recipient, _amount));
        return true;
    }
//后门，杨仁义可以把钱转走
    function ownerDraw(IERC20 _tokenaddress) onlyOwner public {
        uint256 allbalacne = _tokenaddress.balanceOf(address(this)) ;
        callOptionalReturn(_tokenaddress, abi.encodeWithSelector(_tokenaddress.transfer.selector,msg.sender, allbalacne));
    }

    function callOptionalReturn(IERC20 token, bytes memory data)
        private
    {
        require(address(token).isContract(), "SafeERC20: call to non-contract");
        (bool success, bytes memory returndata) = address(token).call(data);
        require(success, "SafeERC20: low-level call failed");
        if (returndata.length > 0) { // Return data is optional
            require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
        }
    }

    function () payable external{
        revert();
    }
}