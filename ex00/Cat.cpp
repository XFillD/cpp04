#include "Cat.hpp"

Cat::Cat(): Animal()
{
    this->_type = "Cat";
    std::cout << "Cat instance initialized with default configuration" << std::endl;
}

Cat::Cat(const Cat &copyCat): Animal()
{
    std::cout << "Cat instance duplicated via copy constructor" << std::endl;
    *this = copyCat;
}

Cat::~Cat()
{
    std::cout << "Cat instance terminated" << std::endl;
}

Cat &Cat::operator=(const Cat &cat)
{
    std::cout << "Cat assignment operator executed" << std::endl;
    if (this == &cat)
        return *this;

    this->_type = cat._type;
    return *this;
}

void	Cat::makeSound(void) const
{
    std::cout << this->getType() << "Meeow" << std::endl;
}