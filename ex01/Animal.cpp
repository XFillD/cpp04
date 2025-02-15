#include "Animal.hpp"

Animal::Animal():_type("default")
{
    std::cout << "Animal Default Constructor called" << std::endl;
}

Animal::Animal(const Animal &copyAnimal)
{
    std::cout << "Animal Copy Constructor called" << std::endl;
    *this = copyAnimal;
}

Animal::~Animal()
{
    std::cout << "Animal Deconstructor called" << std::endl;
}

Animal &Animal::operator=(const Animal &ani)
{
    std::cout << "Animal Assignation operator called" << std::endl;
    if (this == &ani)
        return *this;
    this->_type = ani._type;
    return *this;
}

void Animal::makeSound(void)const
{
    std::cout << "This animal remains silent." << std::endl;
}

std::string Animal::getType(void)const
{
    return (this->_type);
}