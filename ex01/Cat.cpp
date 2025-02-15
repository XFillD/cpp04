#include "Cat.hpp"

Cat::Cat(): Animal()
{
    std::cout << "Cat object created using default constructor." << std::endl;
    this->_type = "Cat";
    this->_brain = new Brain();
    if (this->_brain == NULL)
    {
        perror("Cat Brain allocation error.");
        std::cerr << "Terminating process." << std::endl;
        exit(1);
    }
}

Cat::Cat(const Cat &copyCat): Animal()
{
    std::cout << "Cat object created via copy constructor." << std::endl;
    *this = copyCat;
}

Cat::~Cat()
{
    delete(this->_brain);
    std::cout << "Cat object destroyed." << std::endl;
}

Cat &Cat::operator=(const Cat &cat)
{
    std::cout << "Cat object copy-assigned." << std::endl;
    if (this == &cat)
        return *this;
    this->_type = cat._type;
    this->_brain = new Brain();
    if (this->_brain == NULL)
    {
        perror("Cat Brain allocation error.");
        std::cerr << "Terminating process." << std::endl;
        exit(1);
    }
    *this->_brain = *cat._brain;
    return *this;
}

void Cat::makeSound(void)const
{
    std::cout << this->getType() << "Meeow" << std::endl;
}

void Cat::getIdeas(void)const
{
    for (int i = 0; i < 3; i++)
        std::cout << "\tIdea " << i << " of the Cat: \"" << this->_brain->getIdea(i) << "\" located at " << this->_brain->getIdeaAddress(i) << std::endl;
}

void Cat::setIdea(size_t i, std::string idea)
{
    this->_brain->setIdea(i, idea);
}