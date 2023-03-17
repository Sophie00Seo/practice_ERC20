// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import './EIP712.sol';

contract ERC20 is EIP712{

    // state variables
    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowances;
    uint256 private _totalSupply;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    address _maker;

    bool _paused;
    mapping(address => uint256) private _nonce;

    // Event: To Find Internal Transaction easily
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // constructor
    constructor(string memory name_, string memory symbol_)EIP712(name_, symbol_){
        _name = name_;
        _symbol = symbol_;
        _decimals = 18;
        balances[msg.sender] = 100 ether;
        _totalSupply = 100 ether;
        _paused = false;
        _maker = msg.sender;
    }

    // view functions
    function name() public view returns (string memory){
        return _name;
    }

    function symbol() public view returns (string memory){
        return _symbol;
    }

    function decimals() public view returns (uint8){
        return _decimals;
    }

    function totalSupply() public view returns (uint256){
        return _totalSupply;
    }

    function balanceOf(address _owner) public view returns (uint256){
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value) external returns (bool success){
        require(_paused == false, "paused");
        require(_to != address(0), "transfer to zero address"); // Internal Transfer -> if _to zero address, same as burn
        require(balances[msg.sender] >= _value, "value exceeds balance");

        unchecked {
            balances[msg.sender] -= _value;
            balances[_to] += _value;
        }

        emit Transfer(msg.sender, _to, _value);
        // return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success){
        require(_paused == false, "paused");
        require(_spender != address(0), "approve to the zero address");

        allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }

    function allowance(address _owner, address _spender) public view returns (uint256 remaining){
        return allowances[_owner][_spender];
    }

    function transferFrom(address _from, address _to, uint256 _value) external returns (bool success){
        require(_paused == false, "paused");
        require(_from != address(0), "transfer from zero address");
        require(_to != address(0), "transfer to zero address");
        require(allowances[_from][_to] >= _value, "value exceeds allowance");
        require(balances[_from] >= _value, "value exceeds balance");

        unchecked {
            balances[_from] -= _value;
            balances[_to] += _value;
            allowances[_from][_to] -= _value;
        }

        emit Transfer(_from, _to, _value);
    }

    function _mint(address _owner, uint256 _value) internal {
        require(_paused == false, "paused");
        require(_owner != address(0), "mint to zero address");
        
        _totalSupply += _value;
        unchecked {
            balances[_owner] += _value;
        }
        emit Transfer(address(0), _owner, _value);
    }
    function _burn(address _owner, uint256 _value) internal { // can use not only internal but also public, onlyOwner
    require(_paused == false, "paused");
        require(_owner != address(0), "burn from zero address");
        require(balances[_owner] >= _value, "burn amount exceeds balance");

        unchecked{
            balances[_owner] -= _value;
            _totalSupply -= _value;
        }

        emit Transfer(_owner, address(0), _value);
    }

    function pause() external {
        require(msg.sender == _maker, "not owner");
        _paused = true;
    }

    function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external {

    } // approve+signature

    function nonces(address addr) public returns (uint){
        return _nonce[addr];
    }
}