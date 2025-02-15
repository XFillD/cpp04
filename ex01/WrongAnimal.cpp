#include "WrongAnimal.hpp"

WrongAnimal::WrongAnimal():_type("wrong_default")
{
    std::cout << "Default constructor for WrongAnimal executed." << std::endl;
}

WrongAnimal::WrongAnimal(const WrongAnimal &copyWronga)
{
    std::cout << "Copy constructor for WrongAnimal invoked." << std::endl;
    *this = copyWronga;
}

WrongAnimal::~WrongAnimal()
{
    std::cout << "Destructor for WrongAnimal executed." << std::endl;
}

WrongAnimal &WrongAnimal::operator=(const WrongAnimal &wronga)
{
    std::cout << "Assignment operator for WrongAnimal executed." << std::endl;
    if (this == &wronga)
        return *this;
    this->_type = wronga._type;
    return *this;
}

void WrongAnimal::makeSound(void)const
{
    std::cout << this->getType() << "WrongAnimal noise" << std::endl;
}

std::string WrongAnimal::getType(void)const
{
    return this->_type;
}