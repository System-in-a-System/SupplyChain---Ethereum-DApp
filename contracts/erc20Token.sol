// ----------------------------------------------------------------------------
///Implements EIP20 token standard: https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
// ----------------------------------------------------------------------------

pragma solidity >=0.4.21 <0.6.0;

import "./erc20Interface.sol";

// Conforms to the minimum definitions of ERC20Interface
contract ERC20Token is ERC20Interface {

    uint256 constant private MAX_UINT256 = 2**256 - 1;
    // C# like dictionary of adresses and tokens there
    mapping (address => uint256) public balances;
    // C3 like dictionary of adresses and allowences there
    mapping (address => mapping (address => uint256)) public allowed;

    uint256 public totSupply;             // Total number of tokens
    string public name;                   // Descriptive name (i.e. For Dummies Sample Token)
    uint8 public decimals;                // How many decimals to use when displaying amounts
    string public symbol;                 // Short identifier for token (i.e. FDT)

    // Create the new token and assign initial values, including initial amount
    // = initialization code
    constructor(
        uint256 _initialAmount,
        string memory _tokenName,
        uint8 _decimalUnits,
        string memory _tokenSymbol
    ) public {
        balances[msg.sender] = _initialAmount;               // The creator owns all initial tokens
        totSupply = _initialAmount;                        // Update total token supply
        name = _tokenName;                                   // Store the token name (used for display only)
        decimals = _decimalUnits;                            // Store the number of decimals (used for display only)
        symbol = _tokenSymbol;                               // Store the token symbol (used for display only)
    }

    // Transfer tokens from msg.sender to a specified address
    function transfer(address _to, uint256 _value) public returns (bool success) {
        // Check the funds
        require(balances[msg.sender] >= _value,"Insufficient funds for transfer source.");
        
        // Decrement the sender
        balances[msg.sender] -= _value;
        // Increment the reciever
        balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value); //solhint-disable-line indent, no-unused-vars

        return true;
    }

    // Transfer tokens from one specified address to another specified address
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        // Fetch allowance
        uint256 allowance = allowed[_from][msg.sender];
        
        // Check allowed funds
        require(balances[_from] >= _value && allowance >= _value,"Insufficient allowed funds for transfer source.");
        
        // Increment the reciever
        balances[_to] += _value;
        // Decrement the sender
        balances[_from] -= _value;
        // If allowance is not set to a default value
        if (allowance < MAX_UINT256) {
            // Decrement allowance
            allowed[_from][msg.sender] -= _value;
        }

        emit Transfer(_from, _to, _value); //solhint-disable-line indent, no-unused-vars
        
        return true;
    }

    // Return the current balance (in tokens) of a specified address
    function balanceOf(address _owner) public view returns (uint256 balance) {
        // Fetch the amount of tokens from specified adress in the dictionary
        return balances[_owner];
    }

    // Set approval
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowed[msg.sender][_spender] = _value;
        
        emit Approval(msg.sender, _spender, _value); //solhint-disable-line indent, no-unused-vars
        
        return true;
    }

    // Return the allowance count
    function allowance(address _owner, address _spender) public view returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    // Return the total number of tokens in circulation
    function totalSupply() public view returns (uint256 totSupp) {
        return totSupply;
    }
}