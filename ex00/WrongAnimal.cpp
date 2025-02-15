#include "WrongAnimal.hpp"

WrongAnimal::WrongAnimal() : _type("wrong_default")
{
    std::cout << "Default WrongAnimal instance initialized." << std::endl;
}

WrongAnimal::WrongAnimal(const WrongAnimal &copyWronga)
{
    std::cout << "WrongAnimal instance duplicated via copy constructor." << std::endl;
    *this = copyWronga;
}

WrongAnimal::~WrongAnimal()
{
    std::cout << "WrongAnimal instance terminated." << std::endl;
}

WrongAnimal &WrongAnimal::operator=(const WrongAnimal &wronga)
{
    std::cout << "WrongAnimal assignment operator executed." << std::endl;
    if (this == &wronga)
        return *this;

    this->_type = wronga._type;
    return *this;
}

void WrongAnimal::makeSound(void)const
{
    std::cout << this->getType() << "WrongAnimal noise" << std::endl;
}

std::string	WrongAnimal::getType(void)const
{
    return (this->_type);
}