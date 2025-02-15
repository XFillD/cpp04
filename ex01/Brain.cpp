#include "Brain.hpp"

Brain::Brain()
{
    std::cout << "Brain's default constructor executed." << std::endl;
}

Brain::Brain(const Brain &copyBrain)
{
    std::cout << "Brain copied through constructor." << std::endl;
    *this = copyBrain;
}

Brain::~Brain()
{
    std::cout << "Brain destructor executed." << std::endl;
}

Brain &Brain::operator=(const Brain &brain)
{
    std::cout << "Brain assignment operator executed." << std::endl;
    if (this == &brain)
        return *this;
    for (int i = 0; i < 100; i++)
    {
        if (brain._ideas[i].length() > 0)
            this->_ideas[i].assign(brain._ideas[i]);
    }
    return *this;
}

const std::string Brain::getIdea(size_t i) const
{
    if (i < 100)
        return this->_ideas[i];
    else
        return "Index exceeds limit: Only 100 ideas allowed.";
}

const std::string *Brain::getIdeaAddress(size_t i) const
{
    if (i < 100)
    {
        const std::string &stringREF = this->_ideas[i];
        return &stringREF;
    }
    else
        return NULL;
}

void Brain::setIdea(size_t i, std::string idea)
{
    if (i < 100)
        this->_ideas[i] = idea;
    else
        std::cout << "Index out of range: Only 100 ideas allowed." << std::endl;
}